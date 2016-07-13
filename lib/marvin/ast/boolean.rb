module Marvin
  module AST

    # Represents a binary true or false.
    class Boolean < Expression
      value :value, ::Fixnum

      # Returns the boolean equivalent of the integer value representation
      # (+1+ is +true+, +0+ is +false+).
      #
      # @return [TrueClass,FalseClass] The boolean equivalent.
      def to_bool
        value == 1
      end
    end
  end
end
