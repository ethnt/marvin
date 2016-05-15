# require 'log_buddy'

module Marvin

  # Will generate an instruction set from a given abstract syntax tree.
  class CodeGenerator
    attr_accessor :code, :ast, :symbol_table

    # Creates a new code generator.
    #
    # @param [Marvin::AST] ast The AST to generate from.
    # @param [Marvin::SymbolTable] symbol_table The symbol table for the given
    #                                           AST.
    # @return [Marvin::CodeGenerator] A new generator.
    def initialize(ast, symbol_table)
      @ast = ast
      @symbol_table = symbol_table
      @code = nil
      @instructions = InstructionSet.new
      @static_table = StaticTable.new
      @jump_table = JumpTable.new
    end

    # Generates a set of code.
    #
    # @return [String] A string of hexadecimal.
    def generate!

      # Traverse the AST, calling teh correct method for each production.
      traverse_ast!(ast.root)

      # Backpatch the static table.
      backpatch_static_table!

      # Backpatch the jump table.
      backpatch_jump_table!

      # Add a break, just to be safe.
      break!

      # Fill the rest of the stack with '00' if there is space left.
      if @instructions.code.length < 96
        (96 - @instructions.code.length).times do |n|
          break!
        end
      end

      # Output the code in a string format.
      @code = @instructions.code.join(' ')

      Marvin.logger.info("\n")

      @code = @instructions.code.each_slice(8).each do |line|
        Marvin.logger.info(line.join(' '))
      end
    end

    private

    # Traverses the AST, calling a snake case method of the production.
    #
    # @param [Marvin::Node] node The node who's children we're traversing.
    # @return [nil]
    def traverse_ast!(node)

      # Go through all the children of the given node...
      node.children.each do |child|

        # Skip if it isn't a production.
        next unless child.production?

        # Skip if it's a boolean expression.
        next if %w(BooleanExpr).include?(child.content.name)

        # Convert the production name to snake case and convert to a symbol.
        snake_case = child.content.name.gsub(/(.)([A-Z])/, '\1_\2').downcase

        method_name = "encode_#{snake_case}!".to_sym

        # Call the method.
        self.send(method_name, child)

        # Run this method for each child.
        traverse_ast!(child)
      end
    end

    # We don't do anything for blocks, but we need the method anyways.
    #
    # @param [Marvin::Node] node The block production node.
    # @return [nil]
    def encode_block!(node)
    end

    # Handles a variable declaration.
    #
    #   int a
    #
    # This will convert to something like:
    #
    #   A9 00 8D T0 XX
    #
    # It will load the accumulator with a default value (+00+), then store the
    # accumulator in a memory location.
    #
    # @param [Marvin::Node] node The variable declaration production node.
    # @return [nil]
    def encode_variable_declaration!(node)

      # Load the accumulator with a default value (00).
      #
      # A9 00
      load_accumulator!('00')

      # Create a new entry in the static table with the identifier name.
      entry = @static_table.add_entry(node)

      # Store the accumulator with the temporary memory location given by the
      # static table.
      #
      # 8D T0 XX
      store_accumulator!(entry)
    end

    # Handles an assignment statement.
    #
    #   a = 3
    #
    # This will convert to something like:
    #
    #   A9 03 8D T0 XX
    #
    # It will load the accumulator with the value being set and save it to the
    # memory location for that identifier.
    #
    # @param [Marvin::Node] node The assignment statement production node.
    # @return [nil]
    def encode_assignment!(node)
      name = node.children.first.content
      value = node.children.last.content

      # Get the static table entry for the left-hand side of the assignment
      # statement.
      name_entry = @static_table.get_entry(name.lexeme, scope: name.attributes[:scope])

      # If we're assigning a variable to a variable, look up the right side's
      # memory location and use that instead.
      if value.of_kind?(:char)

        # Get the static table entries for the right-hand side of the assignment
        # statement.
        value_entry = @static_table.get_entry(value.lexeme)

        # Load the accumulator from memory. In this case, we're loading the
        # value of the right hand side of the assignment statement.
        #
        # AD T0 XX
        load_accumulator_from_memory!(value_entry)

        # Store the accumulator in the memory location for the left hand side
        # of the assignment statement.
        #
        # 8D T0 XX
        store_accumulator!(name_entry)

      # Now we're assinging a variable to a primitive.
      else

        # If it's a string, we'll add it to the heap. Otherwise, just load it
        # directly.
        if value.of_kind?(:string)

          # Convert the string to hex and add on a break afterwards.
          str = to_hex(value.lexeme.split('"').last) + ['00']

          # Get the address of the string in the heap (96 - the heap size).
          address = to_hex(96 - (@instructions.heap.length + str.length))

          # Add the string to the heap.
          @instructions.add_to_heap(str)

          # Load the accumulator with the string address.
          load_accumulator!(address)

          # We know the address of the string in the heap at this point, so
          # we'll set the address in the static table entry.
          name_entry.address = address

        else

          # Load the accumulator with a hex value.
          #
          # A9 __
          load_accumulator!(to_hex(value.lexeme))

        end

        # Store the accumulator in the memory location for the left hand side
        # of the assignment statement.
        #
        # 8D T0 XX
        store_accumulator!(name_entry)
      end
    end

    # Handles a print production.
    #
    #   print(a)
    #
    # This will convert to something like:
    #
    #   AC T0 XX A2 01 FF
    #
    # We'll load the y-register from a location in memory, load the x-register
    # with the constant +01+, then do a system call.
    #
    # @param [Marvin::Node] node The print statement production node.
    # @return [nil]
    def encode_print!(node)
      child = node.children.first

      return encode_print!(child) if child.production?

      lexeme = child.content.lexeme

      case child.content.kind
      when :char
        # Get the variable memory entry.
        entry = @static_table.get_entry(lexeme)

        # Load the value in memory to the y-register.
        #
        # AC T0 XX
        load_y_register_from_memory!(entry)

        # Look up the type of the value in the static table. If it's an integer,
        # we're going to load the y-register from the memory location. If it's a
        # string, we're going to store the memory location itself in the
        # y-register.
        if entry.type == 'string'
          # Load the x-register with 02.
          #
          # A2 02
          load_x_register_with_constant!(2)
        else
          # Load the x-register with 01.
          #
          # A2 01
          load_x_register_with_constant!(1)
        end
      when :digit
        # Load the y-register with the actual value.
        #
        # A0 __
        load_y_register_with_constant!(lexeme)

        # Load the x-register with 01.
        #
        # A2 01
        load_x_register_with_constant!(1)
      when :boolval
        # If the lexeme is "true", load the y-register with a 01.
        #
        # A0 01
        if lexeme == 'true'
          load_y_register_with_constant!(1)

        # Otherwise load it with a 00.
        #
        # A0 00
        else
          load_y_register_with_constant!(0)
        end

        # Load the x-register with 01.
        #
        # A2 01
        load_x_register_with_constant!(1)
      when :string

      end

      # System call!
      #
      # FF
      system_call!
    end

    # Handle an if statement.
    #
    #   if (a == b) {
    #     print(a)
    #   }
    #
    # This will encode to something like this:
    #
    #   AE T0 XX EC T1 XX D0 J0
    #
    # It will load the x-register with the contents of the left-hand side of the
    # boolean expression, compare the x-register to the contents of the
    # right-hand side, branch on not equals, jumping ahead a number of bytes to
    # after the generated code for the if-true statements.
    #
    # @param [Marvin::Node] node The if statement production node.
    # @return [nil]
    def encode_if_statement!(node)
      # TODO: Separate out the boolean expression into it's own method.
      boolean_expr = node.children.first

      lhs_token, rhs_token = boolean_expr.children.map(&:content).reject { |t| t.of_kind?(:boolop) }

      # If the left-hand side of the boolean expression is a character...
      if lhs_token.of_kind?(:char)

        # Get the memory address of this specific identifier.
        lhs_entry = @static_table.get_entry(lhs_token.lexeme)

        # Load the x-register from the memory location given.
        #
        # AE T0 XX
        load_x_register_from_memory!(lhs_entry)

      # If the left-hand side of the boolean expression is anything but a
      # character, it's primitive.
      else

        # Load the x-register with a constant.
        #
        # A2 __
        load_x_register_with_constant!(lhs_entry.lexeme)
      end

      # If the right-hand side of the boolean expression is a character...
      if rhs_token.of_kind?(:char)

        # Get the memory address of this specific identifier.
        rhs_entry = @static_table.get_entry(rhs_token.lexeme)

        # Compare the x-register to a location in memory.
        #
        # EC T0 XX
        compare_x_register!(rhs_entry)

      # If the right-hand side of the boolean expression is anything but a
      # character, it's primitive.
      else
        # TODO: Deal with primitives. May have to switch the order (load this
        # value as a constant instead of the left-hand side).
      end

      # We're going to add a new jump table entry.
      jump_table_entry = @jump_table.add_entry

      # Now branch to that entry.
      branch!(jump_table_entry)
    end

    # Compare the x-register.
    #
    #   EC T0 XX
    #
    # @param [Marvin::StaticTable::Entry] entry The static table entry.
    # @return [nil]
    def compare_x_register!(entry)
      @instructions.add_to_stack('EC')
      @instructions.add_to_stack(entry.memory_reference)
    end

    # Load the accumulator.
    #
    #   A9 __
    #
    # @param [String] value The bit of hex to add to the
    # @return [nil]
    def load_accumulator!(value)
      @instructions.add_to_stack('A9')
      @instructions.add_to_stack(value)
    end

    # Loads the accumulator from memory.
    #
    #   AD T0 XX
    #
    # @param [Marvin::StaticTable::Entry] entry A static table entry.
    # @return [nil]
    def load_accumulator_from_memory!(entry)
      @instructions.add_to_stack('AD')
      @instructions.add_to_stack(entry.memory_reference)
    end

    # Store the accumulator in memory.
    #
    #   8D T0 XX
    #
    # @param [Marvin::StaticTable::Entry] entry A static table entry.
    # @return [nil]
    def store_accumulator!(entry)
      @instructions.add_to_stack('8D')
      @instructions.add_to_stack(entry.memory_reference)
    end

    # Load the x-register with a constant value.
    #
    #   A2 01
    #
    # @param [String] value One byte of hex.
    # @return [nil]
    def load_x_register_with_constant!(value)
      @instructions.add_to_stack('A2')
      @instructions.add_to_stack(to_hex(value))
    end

    # Load the x-register with a value from memory.
    #
    #   AE T0 XX
    #
    # @param [Marvin::StaticTable::Entry] entry A static table entry.
    # @return [nil]
    def load_x_register_from_memory!(entry)
      @instructions.add_to_stack('AE')
      @instructions.add_to_stack(entry.memory_reference)
    end

    # Load the y-register with a constant.
    #
    #   A0 04
    #
    # @param [String] value One byte of hex.
    # @return [nil]
    def load_y_register_with_constant!(value)
      @instructions.add_to_stack('A0')
      @instructions.add_to_stack(to_hex(value))
    end

    # Load the y-register with a value from memory.
    #
    #   AC T0 XX
    #
    # @param [Marvin::StaticEntry::Entry] entry A static table entry.
    # @return [nil]
    def load_y_register_from_memory!(entry)
      @instructions.add_to_stack('AC')
      @instructions.add_to_stack(entry.memory_reference)
    end

    # Branch to another area of memory.
    #
    #   D0 J0
    #
    # @param [Marvin::JumpEntry::Entry] entry A jump table entry.
    # @return [nil]
    def branch!(entry)
      @instructions.add_to_stack('D0')
      @instructions.add_to_stack(entry.jump_reference)
    end

    # Just a no op.
    #
    #   EA
    #
    # @return [nil]
    def no_op!
      @instructions.add_to_stack('EA')
    end

    # Add a break.
    #
    #  00
    #
    # @return [nil]
    def break!
      @instructions.add_to_stack('00')
    end

    # Perform a system call based on the value of the x-accumulator.
    #
    #   FF
    #
    # @return [nil]
    def system_call!
      @instructions.add_to_stack('FF')
    end

    # Backpatch the static table with real values. Go through, find the
    # temporary values, and replace them with the next available area in
    # memory.
    #
    # @return [nil]
    def backpatch_static_table!
      memory_location_decimal = @instructions.stack.length + 1

      @static_table.entries.each do |entry|
        indexes = @instructions.stack.each_index.select { |i| @instructions.stack[i] == "T#{entry.value}" }

        memory_location_hex = memory_location_decimal.to_s(16).rjust(2, '0').upcase

        indexes.each do |i|
          @instructions.stack[i] = memory_location_hex
          @instructions.stack[i + 1] = '00'
        end

        memory_location_decimal += 1
      end
    end

    # Backpatch the junp table with real values. Go through, find the
    # temporary values, and replace them with the next available area in
    # memory.
    #
    # @return [nil]
    def backpatch_jump_table!
      @jump_table.entries.each do |entry|
        indexes = @instructions.stack.each_index.select { |i| @instructions.stack[i] == "J#{entry.value}" }

        indexes.each do |i|
          distance = (@instructions.stack.length) - i

          @instructions.stack[i] = distance.to_s(16).rjust(2, '0').upcase
        end
      end
    end

    # Converts a primitive to a hex value.
    #
    # @param [String,Integer,TrueClass,FalseClass] value The value to convert.
    # @return [Array<String>] An array of hex values.
    def to_hex(value)
      # Turn it into an integer if we can.
      value = value.to_i if value.to_i.to_s == value

      case value
      when String
        value.each_byte.map { |b| b.to_s(16).rjust(2, '0').upcase }
      when Fixnum
        [value.to_s(16).rjust(2, '0').upcase]
      when TrueClass
        ['01']
      when FalseClass
        ['00']
      else
        # TODO: Error here, cannot convert to hex.
      end
    end
  end
end
