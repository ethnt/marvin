# frozen_string_literal: true

module Marvin
  module AST

    # Represents a binary true or false.
    class Boolean < Expression
      value :_value, ::Fixnum

      # Returns the boolean equivalent of the integer value representation
      # (+1+ is +true+, +0+ is +false+).
      #
      # @return [TrueClass,FalseClass] The boolean equivalent.
      def value
        _value == 1
      end
    end
  end
end
