module Marvin

  # Defines a node in a tree.
  class Node
    include Enumerable
    include Comparable

    attr_accessor :data, :parent, :children

    # Creates a plain node with just the data.
    #
    # @param [Object] data Any object.
    # @param [Marvin::Node] parent The parent of this node.
    # @param [Array<Marvin::Node>] children An array of the children of this
    #                                       node.
    # @return [Marvin::Node] The new Node.
    def initialize(data, parent = nil, children = [])
      @data = data
      @parent = parent
      @children = children
    end

    # Iterate over the parents and children of the node.
    #
    # @example Output the data of each parent and child node.
    #   node = Marvin::Node.new(2)
    #   node.parent = Marvin::Node.new(1)
    #   node.children = [Marvin::Node.new(3)]
    #   node.each { |n| puts n.data } # => "1, 2, 3"
    #
    # @yieldparam [Marvin::Node] block The block given to the parent and
    #                                  children.
    # @yieldreturn The parent and child nodes.
    def each(&block)
      parent.each(&block) if parent
      block.call(self)
      children.each(&block) if children
    end

    # Compares this node's to the given node's data.
    #
    # @param [Marvin::Node] other_node The node we're comparing this node to.
    # @return [Integer] The comparison of the two pieces of data. If the return
    #                   value is +0+, that means that the data is equivalent. If
    #                   not, the value will be +-1+ or +1+, dependent on if the
    #                   left or right values are inequivalent.
    def <=>(other_node)
      return nil unless other_node.is_a?(Marvin::Node)

      data <=> other_node.data
    end

    # A convenience method for +==+.
    #
    # @param [Marvin::Node] other_node The node we're comparing this node to.
    # @return [Boolean] Whether the data of the two nodes is equivalent.
    def eql?(other_node)
      self == other_node
    end
  end
end
