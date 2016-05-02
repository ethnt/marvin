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

      # backpatch_static_table!
      # backpack_jump_table!

      break!

      @code = @instructions.code.join(' ')
    end

    private

    def traverse_ast!(node)
      node.children.each do |child|
        next unless child.production?

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

    # AC T# XX
    def load_y_register_from_memory!(address)
      @instructions.add_to_stack(['AC', "T#{address}", 'XX'])
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

    def to_hex(token)
      return token.to_i(16).to_s.rjust(2, '0') unless token.is_a?(Marvin::Token)

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
