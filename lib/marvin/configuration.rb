module Marvin

  # Provides a way to configure Marvin.
  class Configuration
    attr_accessor :logger, :verbose

    # Creates a new instance of a +Configuration+. Will by default turn
    # verboseness off and use a default +Logger+.
    #
    # @return [Marvin::Configuration] Your default logger!
    def initialize
      @logger  = Marvin::Logger.new
      @verbose = false
    end
  end
end
