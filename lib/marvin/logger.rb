require 'pastel'

module Marvin

  # Logger is responsible for outputting errors and warnings.
  class Logger
    attr_accessor :stdout, :stderr, :warnings, :errors

    # Creates a new Logger.
    #
    # @param [File] stdout Where the STDOUT will go.
    # @param [File] stderr Where the STDERR will go.
    # @return [Marvin::Logger] A new logger.
    def initialize(stdout = $stdout, stderr = $stderr)
      @stdout = stdout
      @stderr = stderr
      @errors = []
      @warnings = []
    end

    # Creates a new informational message.
    #
    # @param [String] text The informational text.
    # @return [String] The informational text back to you.
    def info(text)
      @stdout.puts(text) if Marvin.configuration.verbose

      text
    end

    # Creates a new warning.
    #
    # @param [String] text The warning text.
    # @return [String] The warning text back to you.
    def warning(text)
      @warnings << text

      text
    end

    # Writes out an error.
    #
    # @param [String] text The error text.
    # @return [String] The error text back to you.
    def error(text)
      @stderr.puts Pastel.new.white.on_red(text)

      text
    end
  end
end
