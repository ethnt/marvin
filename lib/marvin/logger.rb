require 'pastel'

module Marvin

  # Logger is responsible for outputting errors and warnings.
  class Logger
    attr_accessor :destination, :verbose, :warnings, :errors

    # Creates a new Logger.
    #
    # @param [File] destination A destination file to log to. Defaults to
    #                           STDOUT.
    # @return [Marvin::Logger] A new logger.
    def initialize(destination = $stdout, verbose = false)
      @destination = destination
      @verbose = verbose
      @errors = []
      @warnings = []
    end

    # Creates a new informational message.
    #
    # @param [String] text The informational text.
    # @return [String] The informational text back to you.
    def info(text)
      destination.puts(text) if @verbose

      text
    end

    # Creates a new warning.
    #
    # @param [String] text The warning text.
    # @return [String] The warning text back to you.
    def warning(text)
      @warnings.push(text)

      destination.puts Pastel.new.yellow("  warning: #{text}")

      text
    end
  end
end
