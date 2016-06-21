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
    # @param [Marvin::Token] other Another token to check against.
    # @return [Boolean] Whether or not the two tokens are equal.
    def ==(other)
      (lexeme == other.lexeme) && (kind == other.kind)
    end

    # Checks the kind in a clearer way.
    #
    # @param [Symbol] _kind A kind.
    # @return [Boolean] Whether the token is of the given kind or not.
    def of_kind?(_kind)
      kind == _kind
    end

    # Prints out the token in the standard way (+<Token kind : "lexeme">+).
    #
    # @return [String] An output of a Token.
    def to_s
      "<Token #{kind} : \"#{lexeme}\">"
    end

    def to_a
      [kind, lexeme]
    end
  end
end
