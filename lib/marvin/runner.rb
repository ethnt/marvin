module Marvin

  # The runner class is the foundation for the actual compiler. It will take the
  # file or input stream and run it through the paces.
  class Runner
    attr_accessor :code, :config

    # Initialize the actual compiler.
    #
    # @return [Marvin::Runner] A runner object.
    def initialize
      @code   ||= nil
      @config ||= Marvin::Configuration.new
    end

    # Run the compiler.
    #
    # @return [Marvin::Runner] This Runner with output code.
    def run!
      fail(ArgumentError, 'No source code given, exiting') if code.nil?

      self
    end

  end
end