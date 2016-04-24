module Marvin

  # A Production is a part of the grammar that encapsulates various tokens. For
  # example, `StatementList` would be a production.
  class Production < Hashie::Dash
    
    # The name of the production.
    property :name

    # Any additional attributes to be passed along.
    property :attributes

    # Prints out the token in the standard way (`<ProductionName>`).
    #
    # @return [String] An output of a Production.
    def to_s
      "<#{name}>"
    end
  end

end
