module Marvin

  # A representation of a tree.
  class Tree
    attr_accessor :root

    # Create a new tree.
    #
    # @param [Marvin::Node, nil] root A root node.
    # @return [Marvin::Tree] This tree.
    def initialize(root = nil)
      @root = root
    end

    # Print out the tree.
    #
    # @return [nil]
    def print_tree
      @root.print_tree(@root.node_depth, nil, lambda { |node, prefix| puts "#{prefix} #{node.content}" })

      nil
    end
  end
end
