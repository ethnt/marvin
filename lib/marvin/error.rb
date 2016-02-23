module Marvin
  class Error < StandardError
    attr_accessor :object

    def initialize(object)
      @object = object
    end
  end

  class LexerError < Error
    def initialize
    end
  end
end
