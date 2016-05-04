module Marvin
  class StaticTable

    attr_accessor :entries

    # Create a new, empty, static table.
    #
    # @return [Marvin::StaticTable] An empty table.
    def initialize
      @entries = {}
    end

    # Add a new entry.
    #
    # @param [Marvin::Identifier] identifier The identifier to add.
    # @return [Hash] The entry in the static table.
    def add_entry(name)
      entry = { address: next_temporary_address! }

      @entries[name] = entry

      entry
    end

    def get_entry(name)
      @entries[name]
    end

    private

    def next_temporary_address!
      return 0 if @entries.empty?

      @entries.map { |e| e.last[:address] }.max + 1
    end
  end
end
