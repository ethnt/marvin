module Marvin

  # A representation of an abstract syntax tree (AST).
  class AST
    attr_accessor :root

    # Create a new AST with a root.
    #
    # @param [Marvin::Node, nil] root A root node, usually a program.
    # @return [Marvin::AST] This AST.
    def initialize(root = nil)
      @root = root
    end

    # Print out the AST.
    #
    # @return [nil]
    def print_tree
      @root.print_tree(@root.node_depth, nil, lambda { |node, prefix| puts "#{prefix} #{node.content}" })

      nil
    end
  end
end
