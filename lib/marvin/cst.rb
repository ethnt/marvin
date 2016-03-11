module Marvin

  # A representation of a concrete syntax tree (CST).
  class CST
    attr_accessor :root

    # Create a new CST with a root.
    #
    # @param [Marvin::Node, nil] root A root node, usually a program.
    # @return [Marvin::CST] This CST.
    def initialize(root = nil)
      @root = root
    end

    # Print out the CST.
    #
    # @return [nil]
    def print_tree
      @root.print_tree(@root.node_depth, nil, lambda { |node, prefix| puts "#{prefix} #{node.content}" })

      nil
    end
  end
end
