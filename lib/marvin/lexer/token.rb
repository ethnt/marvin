require 'securerandom'

module Marvin

  # A Token is a lexeme in the source code, with attached type and other
  # information.
  class Token
    attr_accessor :lexeme, :type, :attributes, :hex

    # Creates a new Token.
    #
    # @param [String] lexeme The actual text of the lexeme.
    # @param [Type] type The type of the token (operator, symbol, etc).
    # @param [Hash] attributes Should include `:line` and `:character`.
    # @return [Marvin::Token] A new token!
    def initialize(lexeme, type, attributes = {})
      @lexeme = lexeme
      @type = type
      @hex = SecureRandom.hex
    end

    # Checks the equality of two Tokens.
    #
    # @param [Marvin::Token] t Another token to check against.
    # @return [Boolean] Whether or not the two tokens are equal.
    def ==(t)
      (self.lexeme == t.lexeme) && (self.type == t.type)
    end
  end
end
