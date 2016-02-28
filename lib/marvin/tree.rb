module Marvin

  # Defines a general-use tree data structure for use with the concrete and
  # abstract syntax trees.
  class Tree
    attr_accessor :root

    # Creates a new tree.
    #
    # @param [Marvin::Node] root The parent node.
    # @return [Marvin::Tree] A new tree!
    def initialize(root = nil)
      @root = root
    end
  end
end
