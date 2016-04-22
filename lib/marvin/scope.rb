module Marvin

  # A Scope is a part of the grammar that encapsulates various tokens. For
  # example, `Block` would be a scope.
  class Scope < Node

    # Finds any identifiers in this scope and its parent scopes.
    #
    # @param [String] name The name of the identifier.
    # @return [Marvin::Identifier,nil]
    def find_identifier(name, current_only: false)
      identifiers = children.select { |n| n.content.is_a?(Identifier) && n.content.name == name }.map { |n| n.content }.reject { |n| n.type.nil? }

      return identifiers.last unless identifiers.empty?

      return parent.find_identifier(name) if parent && !current_only

      nil
    end

    # Prints out the token in the standard way (`<ScopeName>`).
    #
    # @return [String] An output of a Scope.
    def to_s
      "<#{@name}>"
    end
  end

end
