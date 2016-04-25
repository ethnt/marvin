require 'tree'
require 'securerandom'

module Marvin

  # Subclass and namespace +Tree::TreeNode+.
  class Node < ::Tree::TreeNode
    attr_reader :children_hash

    # Creates a new Node. Automatically sets the name to a random string.
    #
    # @param [Object] content Whatever content that should be in the node.
    # @return [Marvin::Node] The new node.
    def initialize(content)
      super(SecureRandom.hex, content)
    end

    # Checks to see if the content is a Production.
    #
    # @return [Boolean] Whether or not this contains a Production.
    def production?
      @content.is_a?(Production)
    end

    # Checks to see if the content is a Token.
    #
    # @return [Boolean] Whether or not this contains a Token.
    def token?
      @content.is_a?(Token)
    end

    # Resolves the type of the content of this node. If it contains a
    # Production, it will continue to search the right-most child until it
    # reaches an actual value.
    #
    # @param [Marvin::Scope] scope The scope to search through.
    # @return [String] The type (+int+, +boolean+, or +string+).
    def resolve_type(scope)

      # Resolve the type of any children if it's a production
      return @children.last.resolve_type(scope) if production?

      # Convert the kind to a token.
      type =  case @content.kind
              when :char
                scope.find_identifier(content.lexeme).type
              when :digit
                'int'
              when :boolval
                'boolean'
              when :string
                'string'
              else
                _kind
              end

      type
    end
  end
end
