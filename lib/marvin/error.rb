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
        @kind = @kind.map(&:to_s).join(' or ') if @kind.is_a?(Array)

        # rubocop:disable Metrics/LineLength
        "Expected #{@kind}, found #{@token.kind} \"#{@token.lexeme}\" on line #{@token.attributes[:line]} at character #{@token.attributes[:char]}"
      end
    end
  end
end
