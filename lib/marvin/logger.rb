module Marvin

  # Logger is responsible for outputting errors and warnings.
  class Logger
    attr_accessor :destination, :warnings

    # Creates a new Logger.
    #
    # @param [File] destination A destination file to log to. Defaults to
    #                           STDOUT.
    # @return [Marvin::Logger] A new logger.
    def initialize(destination = $stdout)
      @destination = destination
      @warnings = []
    end

    # Creates a new informational message.
    #
    # @param [String] text The informational text.
    # @return [String] The informational text back to you.
    def info(text)
      destination.puts text

      text
    end

    # Creates a new warning.
    #
    # @param [String] text The warning text.
    # @return [String] The warning text back to you.
    def warning(text)
      @warnings.push(text)

      destination.puts "warning: #{text}"

      text
    end
  end
end
