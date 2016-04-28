module Marvin
  class CodeGenerator
    attr_accessor :ast, :config

    # Creates a new code generator.
    #
    # @param [Marvin::AST] ast The AST to generate from.
    # @param [Marvin::Configuration] config Configuration instance.
    # @return [Marvin::CodeGenerator] A new generator.
    def initialize(ast, config: Marvin::Configuration.new)
      @ast = ast
      @config = config
      # @code = Array.new(256, '00')
      @code = []

      @x_register = nil
      @y_register = nil
      @accumulator = nil

      @static_table = StaticTable.new
    end

    # Generates a set of code.
    #
    # @param [String] A string of hexadecimal.
    def generate!
      traverse_ast!(ast.root)

      @code
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
      load_accumulator!('00')
      store_accumulator!()
    end

    def encode_assignment!(node)
      load_accumulator!()
      store_accumulator!()
    end

    def load_accumulator!(value)
      @code << 'A9'
      @code << value
    end

    def store_accumulator!(location)
      @code << '8D'

      @code.concat(@static_table.add_entry(identifier))
    end

    def add_with_carry!()
    end

    def no_op!
      @code << 'EA'
    end

    def break!
      @code << '00'
    end
  end
end
