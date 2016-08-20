# frozen_string_literal: true

require 'slop'

module Marvin

  # This is for interacting with Marvin from the command line.
  class Command

    # Takes in command-line arguments and runs Marvin.
    #
    # @param [Array] args The command-line arguments.
    # @return [Marvin::AST::Program] AST output.
    def self.parse!(args = ARGV)
      opts = Slop.parse(args, help: true) do
        banner 'Usage: marvin [options]'

        on 'f', 'file=', 'An input file to compile.'
        on 'i', 'input=', 'Pass input directly into Marvin.'
        on 'v', 'verbose', 'Turns on verbose mode.'
      end

      Marvin.configure do |c|
        c.verbose = opts[:verbose]
      end

      runner = Marvin::Runner.new(File.read(opts[:file]) || opts[:input])

      ast = runner.run!

      Marvin.logger.stdout.puts(ast)
    end
  end
end
