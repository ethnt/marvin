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
      entry = get_entry(name)

      if entry
        key = next_temporary_value

        @entries[key] = { variable: identifier.name, address: 'XX' }

        [key, 'XX']
      else
        @entries[entry.keys.first].merge(value: identifier.encoded_value)
      end
    end

    def get_entry(name)
      @entries.select { |k| @entries[k][:identifier] == name }
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
