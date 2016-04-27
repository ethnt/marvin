module Marvin

  # An instance of this class will be attached to Marvin for easy access to
  # information like loggers.
  class Configuration

    # Contains all of the different setting options. Each symbol in this array
    # is accessible through getters and setters, but also a method to check if
    # the value is set or not.
    SETTINGS = [:logger, :verbose].freeze

    # For each setting in +SETTINGS+, we're going to set an attribute accessor
    # and define a method to check and see if that setting has a value.
    SETTINGS.each do |setting|
      attr_accessor setting

      # Sets a method +setting?+ for each setting and will check and see if
      # the setting is set.
      define_method "#{setting}?" do
        !(send(setting).nil? || send(setting) == [])
      end
    end

    # The initializer just sets some defaults.
    #
    # @return [Marvin::Configuration] A default configuration instance.
    def initialize
      @logger = Marvin::Logger.new
    end

    # Sets the verbosity level.
    #
    # @param [Boolean] val Whether verbosity should be turned on or not.
    # @return [Boolean] The value back to you.
    def verbose=(val)
      @logger.verbose = val
    end
  end
end
