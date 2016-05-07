module Marvin

  # A Scope is a part of the grammar that encapsulates various tokens. For
  # example, +Block+ would be a scope.
  class Scope < Node

    # Finds any identifiers in this scope and its parent scopes.
    #
    # @param [String] name The name of the identifier.
    # @return [Marvin::Identifier,nil]
    def find_identifier(name, current_only: false)
      # Get the nodes with identifiers as the content, grab all of their
      # contents (the identifier objects), only keep the ones where the name
      # is equivalent to the name passed in, and reject those with no types.
      identifiers = children.select(&:identifier?).map(&:content).select { |i| i.name == name }.reject { |i| i.type.nil? }

      # If we have identifiers, return the last one.
      return identifiers.last unless identifiers.empty?

      # At this point, we have no identifiers. Now try searching the parent.
      return parent.find_identifier(name) if parent && !current_only

      # If we're SOL at this point, just return nil.
      nil
    end

    # Prints out the token in the standard way (+<ScopeName>+).
    #
    # @return [String] An output of a Scope.
    def to_s
      "<Scope #{@content}>"
    end
  end

end
