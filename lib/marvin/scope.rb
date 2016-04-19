module Marvin

  # A Scope is a part of the grammar that encapsulates various tokens. For
  # example, `Block` would be a scope.
  class Scope < Node

    # Finds any identifiers in this scope and its parent scopes.
    #
    # @param [String] name The name of the identifier.
    # @return [Marvin::Identifier,nil]
    def find_identifier(name)
      own_ids = children.select do |n|
        n.content.is_a?(Identifier) && n.content.name == name
      end

      return own_ids unless own_ids.empty?

      return parent.find_identifier(name) if parent

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
