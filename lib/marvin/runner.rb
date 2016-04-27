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

      # Split the input with +$+ so we can run multiple programs.
      programs = @source.split(/(?<=[$])/).reject { |p| p == "\n" }

      programs.each_with_index do |program, i|
        @config.logger.info("\n-----------------------------------\n") if i > 0

        @config.logger.info(Pastel.new.bold("Compiling program ##{i}...\n"))

        @lexer = Marvin::Lexer.new(program, config: @config)
        @lexer.lex!

        @parser = Marvin::Parser.new(@lexer.tokens, config: @config)
        @parser.parse!

        @config.logger.info("\n") unless @config.logger.warnings.empty?

        @config.logger.warnings.each do |warning|
          @config.logger.info(Pastel.new.yellow("warning: #{warning}"))
        end
      end

      self
    end
  end
end
