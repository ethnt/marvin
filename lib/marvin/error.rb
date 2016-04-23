# encoding: utf-8
# rubocop:disable Metrics/LineLength

require 'pastel'

module Marvin

  # Namespacing all of the error types together.
  module Error

    # A lexer error, where an unknown token was found.
    class LexerError

      # Creates a new lexer error.
      #
      # @param [String] str The string where we're having issues.
      # @param [Marvin::Configuration] config A configuration instance
      # @return [Marvin::LexerError] The error.
      def initialize(str, config: Marvin::Configuration.new)
        config.logger.error("Fatal error: unexpected non-token character \"#{str}\".")

        exit
      end
    end

    # A parser error, where we expect a certain type of token but recieve
    # something else.
    class ParseError

      # Creates a new parser error.
      #
      # @param [Marvin::Token] token The token we're having issues with.
      # @param [Symbol, Array<Symbol>] kind The kind (or kinds) expected.
      # @param [Marvin::Configuration] config A configuration instance
      # @return [Marvin::ParserError] The error.
      def initialize(token, kind, config: Marvin::Configuration.new)
        kind = kind.map(&:to_s).join(' or ') if kind.is_a?(Array)

        config.logger.error("Fatal error: expected #{kind}, found #{token.kind} \"#{token.lexeme}\" on line #{token.attributes[:line]} at character #{token.attributes[:char]}.")

        exit
      end
    end

    # An out-of-scope error, where an identifier was referenced that wasn't able
    # to be found within the current scope or any of its ancestors.
    class ScopeError

      # Creates a new out-of-scope error.
      #
      # @param [String] token The char token in question.
      # @param [Marvin::Configuration] config A configuration instance
      # @return [Marvin::ScopeError] The error.
      def initialize(token, config: Marvin::Configuration.new)
        config.logger.error("Fatal error: out-of-scope identifier #{token.lexeme} on line #{token.attributes[:line]} at character #{token.attributes[:char]}")

        exit
      end
    end

    # A type error, where an identifier was declared as a certian type but
    # assigned a value of another type.
    class TypeError

      # Creates a new out-of-scope error.
      #
      # @param [String] node The node containing the type error.
      # @param [String] declared_type The type that was expected.
      # @param [String] given_type The actual type.
      # @param [Marvin::Configuration] config A configuration instance
      # @return [Marvin::ScopeError] The error.
      def initialize(node, declared_type, given_type, config: Marvin::Configuration.new)
        token = if node.is_token?
                  node.content
                else
                  node.children.select(&:is_token?).last.content
                end

        config.logger.error("Fatal error: type mismatch at #{token.lexeme} on line #{token.attributes[:line]} at character #{token.attributes[:char]} (expected #{declared_type}, received #{given_type})")

        exit
      end
    end
  end
end
