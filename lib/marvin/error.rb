require 'pastel'

module Marvin

  # Namespacing all of the error types together.
  module Error

    # A Lexer error.
    class LexerError

      # Creates a new Lexer error.
      #
      # @param [String] str The string where we're having issues.
      # @return [Marvin::LexerError] The error.
      def initialize(str)
        @str = str

        $stderr.puts Pastel.new.white.on_red("Unexpected non-token character \"#{@str}\".")

        exit
      end
    end

    # A Parser error.
    class ParseError

      # Creates a new Parser error.
      #
      # @param [Marvin::Token] token The token we're having issues with.
      # @param [Symbol, Array<Symbol>] kind The kind (or kinds) expected.
      # @return [Marvin::ParserError] The error.
      def initialize(token, kind)
        @token = token
        @kind = kind

        @kind = @kind.map(&:to_s).join(' or ') if @kind.is_a?(Array)

        # rubocop:disable Metrics/LineLength
        $stderr.puts Pastel.new.white.on_red("Fatal error: expected #{@kind}, found #{@token.kind} \"#{@token.lexeme}\" on line #{@token.attributes[:line]} at character #{@token.attributes[:char]}")

        exit
      end
    end
  end
end
