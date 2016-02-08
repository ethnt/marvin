require_relative 'lexer/token'

module Marvin
  class Lexer
    attr_accessor :tokens

    # Create the new lexer.
    #
    # @param [StringIO] stream The stream of input.
    def initialize(stream)
      @stream = stream
      @tokens = []
    end

    # Run the lexer and find the tokens in the input stream.
    #
    # @return [[Token]] An array of tokens found in the stream.
    def lex!
      # We'll cheat a little...
      @tokens = @stream.split(Marvin::Grammar::Delimiters).reject(&:empty?).map do |lexeme|
        token = check_for_lexemes(lexeme)

        if token.nil?
          lexeme
        else
          token
        end
      end
    end

    private

    def check_for_lexemes(str)
      specs = Marvin::Grammar::Specifications.freeze

      # Loop through the grammar, looking for matches.
      specs.each do |expr|
        if !expr.match(str).nil?
          return Marvin::Token.new(str, expr)
        end
      end
    end
  end
end
