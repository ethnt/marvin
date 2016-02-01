module Marvin

  # An instance of this class will be attached to Marvin for easy access to
  # information like loggers.
  class Configuration
    SETTINGS = [:logger].freeze

    # For each setting in `SETTINGS`, we're going to set an attribute accessor
    # and define a method to check and see if that setting has a value.
    SETTINGS.each do |setting|
      attr_accessor setting

      # Sets a method `setting?` for each setting and will check and see if
      # the setting is set.
      define_method "#{setting}?" do
        !(send(setting).nil? || send(setting) == [])
      end
    end

    # The initializer just sets some defaults.
    #
    # @return [Marvin::Configuration] A default configuration instance.
    def initialize
      @logger = STDOUT
    end
  end
end
