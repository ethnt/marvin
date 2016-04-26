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
      @code = ''

      @x_register = nil
      @y_register = nil
      @accumulator = nil

      @static_table = StaticTable.new
    end

    # Generates a set of code.
    #
    # @param [String] A string of hexadecimal.
    def generate!

    end

    private

    def load_accumulator!(value)
      @code << 'A9'
      @code << value
    end

    def store_accumulator!(identifier)
      @code << 'AD'

      @static_table.add_entry(identifier)
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
