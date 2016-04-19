module Marvin

  # A Production is a part of the grammar that encapsulates various tokens. For
  # example, `StatementList` would be a production.
  class Identifier
    attr_accessor :name, :type, :value, :attributes

    # Creates a new Production.
    #
    # @param [String] name The name of the production (e.g., `StatementList`).
    # @param [Hash, nil] attributes Whatever extra attributes to include.
    # @return [Marvin::Production] Your shiny new production!
    def initialize(name, type, value = nil, attributes = {})
      @name = name
      @type = type
      @value = value
      @attributes = attributes
    end

    def of_type?(kind)
      @type.to_s == kind.to_s
    end

    # Prints out the token in the standard way (`<ProductionName>`).
    #
    # @return [String] An output of a Production.
    def to_s
      "<#{@name} : #{@type}>"
    end
  end

end
