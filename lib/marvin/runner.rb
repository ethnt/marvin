module Marvin

  # A runner for running Marvin with input.
  class Runner

    # Creates a new runner.
    #
    # @param [String] input The source code.
    # @return [Marvin::Runner] A new runner.
    def initialize(input)
      @input = input
    end

    # Runs the runner.
    #
    # @return [Marvin::AST::Program] An AST.
    def run!
      tokens = Marvin::Lexer.lex(@input)
      ast    = Marvin::Parser.parse(tokens)

      ast
    end
  end
end
