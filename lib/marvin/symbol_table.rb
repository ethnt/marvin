module Marvin

  # Contains scopes and their child variable types, keys, and values.
  class SymbolTable < Tree
    # Print out the tree.
    #
    # @return [nil]
    def print_tree
      @root.print_tree(@root.node_depth, nil, lambda { |node, prefix| puts "#{prefix} #{node.is_a?(Marvin::Variable) ? node.to_s : node.content}" })

      nil
    end
  end
end
