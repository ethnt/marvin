module Marvin

  # A Variable is a part of the grammar that encapsulates various tokens. For
  # example, `Block` would be a Variable.
  class Identifier < ::Tree::TreeNode
    # attr_accessor :key, :type, :attributes

    # Creates a new Variable.
    #
    # @param [String] name The name of the Variable (e.g., `StatementList`).
    # @param [Hash, nil] attributes Whatever extra attributes to include.
    # @return [Marvin::Variable] Your shiny new Variable!
    def initialize(name = '', type = '', attributes = {})
      super(name, attributes.merge(type: type))
    end

    # Prints out the token in the standard way (`<VariableName>`).
    #
    # @return [String] An output of a Variable.
    def to_s
      "<Identifier #{@content[:type]} : #{@name} (#{@content[:value]})>"
    end
  end

end
