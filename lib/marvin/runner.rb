require 'pastel'

module Marvin

  # The runner class is the foundation for the actual compiler. It will take the
  # file or input stream and run it through the paces.
  class Runner
    attr_accessor :source, :config, :lexer, :parser

    # Initialize the actual compiler.
    #
    # @return [Marvin::Runner] A runner object.
    def initialize
      @source ||= nil
      @config ||= Marvin::Configuration.new
    end

    # Run the compiler.
    #
    # @return [Marvin::Runner] This Runner with output code.
    def run!
      fail(ArgumentError, 'No source code given, exiting') if source.nil?

      @source.split(/(?<=[$])/).reject { |p| p == "\n" }.each do |program|
        @lexer = Marvin::Lexer.new(program, @config)
        @lexer.lex!

        @parser = Marvin::Parser.new(@lexer.tokens, config: @config)
        @parser.parse!

        $stdout.puts "\n"

        @config.logger.warnings.each do |warning|
          $stdout.puts Pastel.new.yellow("warning: #{warning}")
        end

        $stdout.puts "\n"
      end

      self
    end
  end
end
