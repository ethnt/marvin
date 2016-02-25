module Marvin

  # A custom error class.
  class Error < StandardError
    attr_accessor :object

    # Creates a new Error.
    #
    # @param [Object] object The object we're having issues with.
    # @return [Marvin::Error] The error.
    def initialize(object)
      @object = object
    end
  end

  # A Lexer error.
  class LexerError < Error

    # Creates a new Lexer error.
    #
    # @param [Object] object The object we're having issues with.
    # @return [Marvin::Error] The error.
    def initialize(object)
      super(object)
    end
  end

  # A Parser error.
  class ParserError < Error

    # Creates a new Lexer error.
    #
    # @param [Marvin::Token] token The token we're having issues with.
    # @param [Symbol, Array<Symbol>] kind The kind (or kinds) expected.
    # @return [Marvin::Error] The error.
    def initialize(token, kind)
      @token = token
      @kind = kind
    end

    # The message for the error.
    def message
      if @kind.is_a?(Array)
        @kind_str = @kind.map(&:to_s).map(&:upcase).join(' or ')
      else
        kind_str = @kind.to_s.upcase
      end

      "Expected #{@kind.to_s.upcase}, found #{@token.kind.to_s.upcase} \"#{@token.lexeme}\" on line #{@token.attributes[:line]} at character #{@token.attributes[:char]}"
    end
  end
end
