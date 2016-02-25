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
      if @verbose
        destination.puts text
      end

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

    # Creates a new error and quits.
    #
    # @param [String] text The error text.
    # @return [String] The error text back to you.
    def error(text)
      @errors.push(text)

      destination.puts text

      exit(-1)
    end
  end
end
