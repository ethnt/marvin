require 'digest/md5'

module Marvin

  # A Token is a lexeme in the source code, with attached type and other
  # information.
  class Token
    attr_accessor :lexeme, :kind, :attributes

    # Creates a new Token.
    #
    # @param [String] lexeme The actual text of the lexeme.
    # @param [Type] kind The type of the token (operator, symbol, etc).
    # @param [Hash] attributes Should include `:line` and `:character`.
    # @return [Marvin::Token] A new token!
    def initialize(lexeme, kind, attributes = {})
      @lexeme = lexeme
      @kind = kind
      @attributes = attributes
    end

    # Checks the equality of two Tokens.
    #
    # @param [Marvin::Token] t Another token to check against.
    # @return [Boolean] Whether or not the two tokens are equal.
    def ==(t)
      (self.lexeme == t.lexeme) && (self.kind == t.kind)
    end

    # Prints out the token in the standard way (`<Token kind : "lexeme">`).
    #
    # @return [String] An output of a Token.
    def to_s
      "<Token #{kind} : \"#{lexeme}\">"
    end
  end
end
