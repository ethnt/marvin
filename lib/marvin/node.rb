require 'tree'
require 'securerandom'

module Marvin

  # Subclass and namespace +Tree::TreeNode+.
  class Node < ::Tree::TreeNode
    attr_reader :children_hash

    def initialize(content)
      super(SecureRandom.hex, content)
    end

    def is_production?
      @content.is_a?(Production)
    end

    def is_token?
      @content.is_a?(Token)
    end

    def find_child(_name)
      @children_hash[name]
    end

    def resolve_type
      # Resolve the type of any children if it's a production
      return @children.last.resolve_type if is_production?

      k = @content.kind

      if k == 'boolval'
        k = 'boolean'
      end

      return k
    end

    # Finds in the current nodes children and any of the ancestors.
    def find_in_parentage(_name)
      result = nil

      parentage.each do |parent|
        result = parent.children_hash[_name]

        break if result
      end

      # search.empty? ? nil : search.first
      result
    end
  end
end
