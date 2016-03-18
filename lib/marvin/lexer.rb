require 'strscan'

module Marvin

  # The Lexer will search through the source code for Tokens.
  class Lexer
    attr_accessor :tokens, :config

    # Creates a new Lexer with a given source code and config.
    #
    # @param [String] source Source code.
    # @param [Marvin::Configuration] config config instance.
    # @return [Marvin::Lexer] An un-run lexer.
    def initialize(source, config = Marvin::Configuration.new)
      @scanner = StringScanner.new(source)
      @tokens = []
      @config = config
    end

    # Run the actual lexer.
    #
    # @return [Array<Marvin::Token>] An Array of Tokens from the source code.
    def lex!
      @config.logger.info 'Lexing...'

      # Continue until we reach the end of the string.
      until @scanner.eos?

        # If we match a space at the pointer, go to the next iteration.
        next unless @scanner.scan(/\s/).nil?

        # Look for any tokens at the current pointer.
        token = find_token!

        # If we have a token, advance by the length of the lexeme and add the
        # token to our token array.
        if token
          @scanner.pos += token.lexeme.length
          @tokens << token
          @config.logger.info("  #{token}")

        # Otherwise, we error out!
        else
          fail Marvin::Error::LexerError.new(@scanner.getch)
        end

        next
      end

      # Fix some small stuff.
      fix_small_errors!

      @config.logger.info "Found #{@tokens.count} tokens.\n\n"

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
      Marvin::Grammar::Lexemes.values.each do |expr|

        # If we get a match from StringScanner#match?, it will return the
        # length of the match and nil otherwise.
        len = @scanner.match?(expr)

        # We've got a match!
        if len && len > 0

          # Peek the length of the match ahead to get the lexeme.
          lexeme = @scanner.peek(len)

          # The kind matches up in the spec hash.
          kind = Marvin::Grammar::Lexemes.key(expr)

          # Grab the line from the overall character number.
          attributes = {
            line: line_from_char(@scanner.pos),
            char: char_on_line(@scanner.pos)
          }

          # Make the new token.
          token = Marvin::Token.new(lexeme, kind, attributes)

          # Break out of the loop, since we've found a match.
          break
        end
      end

      token
    end

    # Fixes some small errors.
    #
    # @return [nil]
    def fix_small_errors!
      if @tokens.last.kind != :program_end
        line = @tokens.last.attributes[:line]
        char = @tokens.last.attributes[:char] + 1

        @tokens << Marvin::Token.new('$', :program_end, { line: line, char: char })

        @config.logger.warning('Missing ending $, adding.')
      end
    end

    # Get the line from the overall character number.
    #
    # @param [Integer] char The overall character number in the document.
    # @return [Integer] The line number.
    def line_from_char(char)
      str = @scanner.string[0..char]
      str.lines.count
    end

    # Get the character number on its line.
    #
    # @param [Integer] char The overall character number in the document.
    # @return [Integer] The character number on its given line.
    def char_on_line(char)
      str = @scanner.string[0..char]

      if newline_char = str.rindex("\n")
        char - newline_char
      else
        char
      end
    end
  end
end
