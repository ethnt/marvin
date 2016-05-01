module Marvin

  # A Production is a part of the grammar that encapsulates various tokens. For
  # example, +StatementList+ would be a production.
  class Identifier < Hashie::Dash

    # The name of the identifier (i.e., the name of the variable).
    property :name

    # The type of the identifier (either +int+, +boolean+, or +string+).
    property :type

    # Whether or not the variable has been assigned.
    property :assigned, default: false

    # Any other attributes, like line or character number.
    property :attributes

    # Checks to see if this variable is of the type given.
    #
    # @param [Symbol,String] kind The kind expected.
    # @return [Boolean] Whether the types match or not.
    def of_type?(kind)
      @type.to_s == kind.to_s
    end

    # Prints out the token in the standard way (+<name : type>+).
    #
    # @return [String] An output of a Production.
    def to_s
      "<#{name} : #{type}>"
    end
  end

end
