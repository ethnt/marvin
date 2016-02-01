module Marvin

  # The runner class is the foundation for the actual compiler. It will take the
  # file or input stream and run it through the paces.
  class Runner
    attr_accessor :config

    # Initialize the actual compiler.
    #
    # @param  [String] code          The actual input code.
    # @param  [Hash]   configuration Any configuration given in. See the
    #                               `Configuration` class for details.
    # @return [String] 0632a target code.
    def initialize(code, configuration = {})
      @config ||= Marvin::Configuration.new
    end

    # class << self
    #
    #   # A class method that will take in a file, rather than a String.
    #   #
    #   # @param  [File]   A file to read from.
    #   # @param  [Hash]   Any configuration given in. See the `Configuration`
    #   #                  class for details.
    #   # @param [String] 0632a target code.
    #   def from_file(file, configuration = {})
    #     # read file...
    #     contents = ''
    #
    #     self.new(contents, configuration)
    #   end
    # end
  end
end
