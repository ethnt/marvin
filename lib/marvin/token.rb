module Marvin

  # A Token is a lexeme in the source code, with attached type and other
  # information.
  class Token < Hashie::Dash

    # The actual source code content of the lexeme.
    property :lexeme

    # The kind of token.
    property :kind

    # Any additional attributes.
    property :attributes

    # Checks the equality of two Tokens.
    #
    # @param [Marvin::Token] t Another token to check against.
    # @return [Boolean] Whether or not the two tokens are equal.
    def ==(other)
      (lexeme == other.lexeme) && (kind == other.kind)
    end

    # Prints out the token in the standard way (+<Token kind : "lexeme">+).
    #
    # @return [String] An output of a Token.
    def to_s
      "<Token #{kind} : \"#{lexeme}\">"
    end
  end
end
