module Marvin

  # Namespacing all of the error types together.
  module Error

    # A Lexer error.
    class LexerError < StandardError

      # Creates a new Lexer error.
      #
      # @param [String] str The string where we're having issues.
      # @return [Marvin::LexerError] The error.
      def initialize(str)
        @str = str
      end

      # The message for the error.
      #
      # @return [String] Says where the issue was.
      def message
        "Unexpected non-token character \"#{@str}\"."
      end
    end

    # A Parser error.
    class ParseError < StandardError

      # Creates a new Parser error.
      #
      # @param [Marvin::Token] token The token we're having issues with.
      # @param [Symbol, Array<Symbol>] kind The kind (or kinds) expected.
      # @return [Marvin::ParserError] The error.
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
