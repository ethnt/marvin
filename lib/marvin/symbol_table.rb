module Marvin

  # Contains scopes and their child variable types, keys, and values.
  class SymbolTable < Hash
    attr_accessor :ast, :root

    # Create a new symbol table with a root.
    #
    # @param [Marvin::AST] ast An AST to generate the symbol table from.
    # @return [Marvin::SymbolTable] This symbol table.
    def initialize(ast)
      @ast = ast
      @root = nil
    end

    # Build the symbol table from the AST.
    def build!
      
    end

    # Print out the symbol table.
    #
    # @return [nil]
    def print_tree
      @root.print_tree(@root.node_depth, nil, lambda { |node, prefix| puts "#{prefix} #{node.content}" })

      nil
    end
  end
end
