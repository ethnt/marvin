module Marvin

  # A Scope is a part of the grammar that encapsulates various tokens. For
  # example, `Block` would be a scope.
  class Variable
    attr_accessor :key, :type, :attributes

    # Creates a new Scope.
    #
    # @param [String] name The name of the scope (e.g., `StatementList`).
    # @param [Hash, nil] attributes Whatever extra attributes to include.
    # @return [Marvin::Scope] Your shiny new scope!
    def initialize(name, type, attributes = {})
      @name = name
      @type = type
      @attributes = attributes
    end

    # Prints out the token in the standard way (`<ScopeName>`).
    #
    # @return [String] An output of a Scope.
    def to_s
      "<#{@name}>"
    end
  end

end
