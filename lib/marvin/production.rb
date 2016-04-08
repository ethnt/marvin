module Marvin

  # A Production is a part of the grammar that encapsulates various tokens. For
  # example, `StatementList` would be a production.
  class Production
    attr_accessor :name, :attributes

    # Creates a new Production.
    #
    # @param [String] name The name of the production (e.g., `StatementList`).
    # @param [Hash, nil] attributes Whatever extra attributes to include.
    # @return [Marvin::Production] Your shiny new production!
    def initialize(name, attributes = {})
      @name = name
      @attributes = attributes
    end

    # Prints out the token in the standard way (`<ProductionName>`).
    #
    # @return [String] An output of a Production.
    def to_s
      "<#{@name}>"
    end
  end

end
