require 'pastel'

module Marvin

  # The runner class is the foundation for the actual compiler. It will take the
  # file or input stream and run it through the paces.
  class Runner
    attr_accessor :source, :lexer, :parser, :code

    # Initialize the actual compiler.
    #
    # @return [Marvin::Runner] A runner object.
    def initialize
      @source ||= nil
    end

    # Run the compiler.
    #
    # @return [Marvin::Runner] This Runner with output code.
    def run!

      # Split the input with +$+ so we can run multiple programs.
      programs = @source.split(/(?<=[$])/).reject { |p| p == "\n" }

      programs.each_with_index do |program, i|
        Marvin.logger.info("\n-----------------------------------\n") if i > 0

        Marvin.logger.info(Pastel.new.bold("Compiling program ##{i}...\n"))

        @lexer = Marvin::Lexer.new(program)
        @lexer.lex!

        @parser = Marvin::Parser.new(@lexer.tokens)
        @parser.parse!

        @code = Marvin::CodeGenerator.new(@parser.ast)
        @code.generate!

        Marvin.logger.info("\n")
        Marvin.logger.stdout.puts @code.code

        Marvin.logger.info("\n") unless Marvin.logger.warnings.empty?

        Marvin.logger.warnings.each do |warning|
          Marvin.logger.info(Pastel.new.yellow("warning: #{warning}"))
        end
      end

      self
    end
  end
end
