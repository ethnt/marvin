module Marvin

  # Logger is responsible for outputting errors and warnings.
  class Logger
    attr_accessor :destination, :warnings, :errors

    # Creates a new Logger.
    #
    # @param [File] destination A destination file to log to. Defaults to
    #                           STDOUT.
    # @return [Marvin::Logger] A new logger.
    def initialize(destination = $stdout)
      @destination = destination
      @warnings = []
      @errors = []
    end

    # Creates a new warning.
    #
    # @param [String] str The warning text.
    # @return [String] The warning text back to you.
    def warning(str)
      @warnings.push(str)

      destination.puts "warning: #{str}"

      return str
    end

    # Creates a new error.
    #
    # @param [String] str The error text.
    # @return [String] The error text back to you.
    def error(str)
      @errors.push(str)

      destination.puts "error: #{str}"

      return str
    end
  end
end
