module Marvin

  # Namespacing all of the error types together.
  module Error

    # A Parser error.
    class ParseError < StandardError

      # Creates a new Lexer error.
      #
      # @param [Marvin::Token] token The token we're having issues with.
      # @param [Symbol, Array<Symbol>] kind The kind (or kinds) expected.
      # @return [Marvin::Error] The error.
      def initialize(token, kind)
        @token = token
        @kind = kind
      end

      # The message for the error.
      #
      # @return [String] Says what was expected and what was given where.
      def message
        if @kind.is_a?(Array)
          @kind_str = @kind.map(&:to_s).map(&:upcase).join(' or ')
        else
          kind_str = @kind.to_s.upcase
        end

        "Expected #{@kind.to_s.upcase}, found #{@token.kind.to_s.upcase} \"#{@token.lexeme}\" on line #{@token.attributes[:line]} at character #{@token.attributes[:char]}"
      end
    end
  end
end
