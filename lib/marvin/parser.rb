module Marvin

  # The Parser will verify the syntax of the found tokens.
  class Parser
    attr_accessor :tokens, :configuration

    # Creates a new Parser with a given Lexer and configuration.
    #
    # @param [[Marvin::Token]] tokens A bunch of tokens.
    # @param [Marvin::Configuration] configuration Configuration instance.
    # @return [Marvin::Parser] An un-run parser.
    def initialize(tokens, configuration = Marvin::Configuration.new)
      @tokens = tokens
      @configuration = configuration
    end

    # Will parse the tokens given.
    #
    # @return [Boolean] Whether the source is valid or not.
    def parse!
      @counter = 0

      parse_program!

      true
    end

    protected

    # Checks whether or not the current token matches the expected kind.
    #
    # @param [Marvin::Token] token The current token to check against.
    # @param [Symbol] kind The expected kind.
    # @return [Boolean] Whether or not the kind matches.
    def match?(token, kind)
      # We have a match.
      if token.kind == kind
        @counter = @counter + 1

        true
      else
        fail Marvin::ParserError.new(current_token, kind)
      end
    end

    # Returns the token at the counter.
    #
    # @return [Marvin::Token] The token at the counter.
    def current_token
      @tokens[@counter]
    end

    def parse_program!
      parse_block!
      match?(current_token, :program_end)
    end

    def parse_block!
      match?(current_token, :block_begin)
      match?(current_token, :block_end)
    end
  end
end
