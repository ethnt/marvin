module Marvin
  class StaticTable

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
    def add_entry(identifier)
      entries[next_temporary_value] = { variable: identifier.name, address: next_address }
    end

    private

    def next_temporary_value
      if @entries.keys.empty?
        'T0'
      else
        "T#{@entries.keys.last.split('T').to_i + 1}"
      end
    end

    def next_address
      if @entries.keys.last
        @entries[@entries.keys.last][:address] + 1
      else
        0
      end
    end
  end
end
