require 'log_buddy'

module Marvin
  class CodeGenerator
    attr_accessor :ast, :code, :config

    # Creates a new code generator.
    #
    # @param [Marvin::AST] ast The AST to generate from.
    # @param [Marvin::Configuration] config Configuration instance.
    # @return [Marvin::CodeGenerator] A new generator.
    def initialize(ast, config: Marvin::Configuration.new)
      @ast = ast
      @config = config
      @code = nil
      @instructions = InstructionSet.new
      @static_table = StaticTable.new
      @jump_table = JumpTable.new
    end

    # Generates a set of code.
    #
    # @param [String] A string of hexadecimal.
    def generate!
      traverse_ast!(ast.root)

      backpatch_static_table!
      backpatch_jump_table!

      break!

      if @instructions.stack.length < 96
        (96 - @instructions.stack.length).times do |n|
          @instructions.add_to_stack('00')
        end
      end

      @code = @instructions.code.join(' ')
    end

    private

    def traverse_ast!(node)
      node.children.each do |child|
        next unless child.production?

        next if %w(BooleanExpr).include?(child.content.name)

        snake_case = child.content.name.gsub(/(.)([A-Z])/, '\1_\2').downcase

        method_name = "encode_#{snake_case}!".to_sym

        self.send(method_name, child)

        traverse_ast!(child)
      end
    end

    def encode_block!(node)
    end

    def encode_variable_declaration!(node)
      load_accumulator!('00') # A9 00

      entry = @static_table.add_entry(node.children.last.content.lexeme)

      store_accumulator!(entry[:address]) # 8D T# XX
    end

    def encode_assignment!(node)
      name = node.children.first.content
      value = node.children.last.content

      # If we're setting a varialbe to a varialbe, look up the right side's memory location
      # and use that instead
      if value.kind == :char
        load_accumulator_from_memory!(@static_table.get_entry(value.lexeme))

        entry = @static_table.get_entry(name.lexeme)

        store_accumulator!(entry[:address])
      else
        load_accumulator!(to_hex(value))

        entry = @static_table.get_entry(name.lexeme)

        store_accumulator!(entry[:address])
      end
    end

    def encode_print!(node)
      # check if we're calling an identifier or a primitive. assume variable for now

      # AC T# XX A2 01 FF
      entry = @static_table.get_entry(node.children.first.content.lexeme)

      load_y_register_from_memory!(entry[:address])
      load_x_register_with_constant!('01')
      system_call!
    end

    def encode_if_statement!(node)
      boolean_expr = node.children.first

      # load x register with contents of left hand side of boolean expr
      lhs_token = boolean_expr.children.first.content

      rhs_token = boolean_expr.children.last.content

      if lhs_token.kind == :char
        lhs_entry = @static_table.get_entry(lhs_token.lexeme)

        load_x_register_from_memory!(lhs_entry[:address])
      else
        # use a primitive
      end

      # compare the x register to the contents of the right hand side of the boolean expr
      if rhs_token.kind == :char
        rhs_entry = @static_table.get_entry(rhs_token.lexeme)

        compare_x_register!(rhs_entry)
      else
        # use a primitive
      end

      # jump!
      jump_table_entry = @jump_table.add_entry(0)

      branch!(jump_table_entry[:temporary_value])
    end

    def compare_x_register!(address)
      @instructions.add_to_stack('EC')
      @instructions.add_to_stack(["T#{address[:address]}", 'XX'])
    end

    def load_accumulator!(value)
      @instructions.add_to_stack('A9')
      @instructions.add_to_stack(value)
    end

    def load_accumulator_from_memory!(address)
      @instructions.add_to_stack('AD')
      @instructions.add_to_stack(["T#{address[:address]}", 'XX'])
    end

    def store_accumulator!(location)
      @instructions.add_to_stack(['8D', "T#{location}", 'XX'])
    end

    def add_with_carry!()
    end

    def load_x_register_with_constant!(value)
      @instructions.add_to_stack('A2')
      @instructions.add_to_stack(to_hex(value))
    end

    def load_x_register_from_memory!(address)
      @instructions.add_to_stack(['AE', "T#{address}", 'XX'])
    end

    # AC T# XX
    def load_y_register_from_memory!(address)
      @instructions.add_to_stack(['AC', "T#{address}", 'XX'])
    end

    def branch!(jump_address)
      @instructions.add_to_stack(['D0', "J#{jump_address}"])
    end

    def no_op!
      @instructions.add_to_stack('EA')
    end

    def break!
      @instructions.add_to_stack('00')
    end

    def system_call!
      @instructions.add_to_stack('FF')
    end

    def backpatch_static_table!
      memory_location_decimal = @instructions.stack.length + 1

      @static_table.entries.each do |k, v|
        temporary_address = v

        indexes = @instructions.stack.each_index.select { |i| @instructions.stack[i] == "T#{v[:address]}" }

        memory_location_hex = memory_location_decimal.to_s(16).rjust(2, '0').upcase

        indexes.each do |i|
          @instructions.stack[i] = memory_location_hex
          @instructions.stack[i + 1] = '00'
        end

        memory_location_decimal += 1
      end
    end

    def backpatch_jump_table!
      @jump_table.entries.each do |entry|
        indexes = @instructions.stack.each_index.select { |i| @instructions.stack[i] == "J#{entry[:temporary_value]}" }

        indexes.each do |i|
          distance = (@instructions.stack.length) - i

          @instructions.stack[i] = distance.to_s(16).rjust(2, '0').upcase
        end
      end
    end

    # HACK: Maybe move this to the Token class, have another method for primitives here
    def to_hex(value)
      return value.to_i(16).to_s.rjust(2, '0') unless value.is_a?(Marvin::Token)

      token = value

      hex = case token.kind
            when :char
              location = @static_table.get_entry(token.lexeme)

              ["T#{location[:address]}", 'XX']
            when :digit
              token.lexeme.to_i(16).to_s.rjust(2, '0')
            end

      hex
    end
  end
end
