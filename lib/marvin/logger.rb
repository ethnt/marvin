module Marvin

  # Logger is responsible for outputting errors and warnings.
  class Logger
    attr_accessor :destination, :warnings, :errors

    def initialize(destination = $stdout)
      @destination = destination
      @warnings = []
      @errors = []
    end

    def warning(str)
      @warnings.push(str)

      destination.puts "warning: #{str}"

      return str
    end

    def error(str)
      @errors.push(str)

      destination.puts "error: #{str}"

      return str
    end
  end
end
