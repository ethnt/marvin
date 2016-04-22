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
        kind = kind.map(&:to_s).join(' or ') if kind.is_a?(Array)

        # rubocop:disable Metrics/LineLength
        $stderr.puts Pastel.new.white.on_red("Fatal error: expected #{kind}, found #{token.kind} \"#{token.lexeme}\" on line #{token.attributes[:line]} at character #{token.attributes[:char]}")

        exit
      end
    end

    # An out-of-scope error.
    class ScopeError

      # Creates a new out-of-scope error.
      #
      # @param [String] token The char token in question.
      # @return [Marvin::ScopeError] The error.
      def initialize(token)
        $stderr.puts Pastel.new.white.on_red("Fatal error: out-of-scope identifier #{token.lexeme} on line #{token.attributes[:line]} at character #{token.attributes[:char]}")

        exit
      end
    end

    # A type error.
    class TypeError

      # Creates a new out-of-scope error.
      #
      # @param [String] node The node containing the type error.
      # @param [String] declared_type The type that was expected.
      # @param [String] given_type The actual type.
      # @return [Marvin::ScopeError] The error.
      def initialize(node, declared_type, given_type)
        token = if node.is_token?
                  node.content
                else
                  node.children.select { |n| n.is_token? }.last.content
                end

        $stderr.puts Pastel.new.white.on_red("Fatal error: type mismatch at #{token.lexeme} on line #{token.attributes[:line]} at character #{token.attributes[:char]} (expected #{declared_type}, received #{given_type})")

        exit
      end
    end
  end
end
