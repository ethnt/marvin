require 'strscan'

module Marvin

  # The Lexer will search through the source code for Tokens.
  class Lexer
    attr_accessor :tokens

    # Define all of the lexemes in the language. We'll look through these every
    # time we advance the pointer on the source.
    LEXEMES = {
      block_begin: /({)/,
      block_end: /(})/,
      type: /(int|string|boolean)/,
      digit: /(\d)/,
      boolval: /(true|false)/,
      boolop: /(==|!=)/,
      intop: /\+/,
      string: /"([a-z\s]*?)"/,
      print: /(print)/,
      if_statement: /(if)/,
      while: /(while)/,
      char: /[a-z]/,
      new_line: /(\n)/,
      assignment: /(=)/,
      open_parenthesis: /\(/,
      close_parenthesis: /\)/,
      program_end: /(\$)/
    }.freeze

    # Creates a new Lexer with a given source code and config.
    #
    # @param [String] source Source code.
    # @return [Marvin::Lexer] An un-run lexer.
    def initialize(source)
      @scanner = StringScanner.new(source)
      @tokens = []
    end

    # Run the actual lexer.
    #
    # @return [Array<Marvin::Token>] An Array of Tokens from the source code.
    def lex!
      Marvin.logger.info 'Lexing...'

      # Continue until we reach the end of the string.
      until @scanner.eos?

        # If we match a space at the pointer, go to the next iteration.
        next unless @scanner.scan(/\s/).nil?

        # Look for any tokens at the current pointer.
        token = find_token!

        # Lexer error if there isn't anything there.
        return Marvin::Error::LexerError.new(@scanner.getch) unless token

        # If we have a token, advance by the length of the lexeme and add the
        # token to our token array.
        @scanner.pos += token.lexeme.length
        @tokens << token
        Marvin.logger.info("  #{token}")

        next
      end

      Marvin.logger.info "Found #{@tokens.count} tokens.\n\n"

      # Check, please!
      @tokens
    end

    private

    # Finds any tokens at the current scanner pointer.
    #
    # @return [Marvin::Token, nil] A token if it finds one or nil.
    def find_token!
      token = nil

      # Run through every regex.
      LEXEMES.values.each do |expr|

        # If we get a match from StringScanner#match?, it will return the
        # length of the match and nil otherwise.
        len = @scanner.match?(expr)

        # If there's no match, just go to the next one.
        next unless len && len > 0

        # Peek the length of the match ahead to get the lexeme.
        lexeme = @scanner.peek(len)

        # The kind matches up in the spec hash.
        kind = LEXEMES.key(expr)

        attributes = location_info(@scanner.pos)

        # Make the new token.
        token = Marvin::Token.new(
          lexeme: lexeme,
          kind: kind,
          attributes: attributes
        )

        # Break out of the loop, since we've found a match.
        break
      end

      token
    end

    # Get the line number and character on line of a given character.
    #
    # @param [Integer] char THe overall character number.
    # @return [Hash] Hash consisting of +:line+ (the line number) and +:char+
    #                (the character number).
    def location_info(char)
      str = @scanner.string[0..char]

      info = {
        line: str.lines.count,
        char: str.rindex("\n") ? char - str.rindex("\n") : char
      }

      info
    end
  end
end
