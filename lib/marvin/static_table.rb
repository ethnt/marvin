module Marvin

  # A static table holds information about memory locations in operation codes.
  class StaticTable
    attr_accessor :entries

    # Create a new, empty, static table.
    #
    # @return [Marvin::StaticTable] An empty table.
    def initialize
      @entries = []
    end

    # Add a new entry.
    #
    # @param [String] name The name of the identifier to add.
    # @return [Marvin::StaticTable::Entry] The entry in the static table.
    def add_entry(name)
      next_value = if @entries.empty?
                     0
                   else
                     @entries.map(&:value).max + 1
                   end

      entry = Entry.new(
        value: next_value,
        name: name
      )

      @entries << entry

      entry
    end

    # Get an entry from the jump table.
    #
    # @param [Integer] value The number in the static table (i.e., 0 from "T0").
    # @return [Marvin::StaticTable::Entry] The entry in the static table.
    def get_entry(value: nil, name: nil)
      return @entries.find { |e| e.value == value } if value
      return @entries.find { |e| e.name == name } if name
    end

    # A basic entry in a static table. Includes the value (i.e., 0), the
    # identifier name, and the address.
    class Entry < Hashie::Dash

      # The value (i.e., the 0 from "T0").
      property :value

      # The name of the identifier.
      property :name

      # The actual address in memory. Defaults to nil.
      property :address, default: nil

      # Return the jump reference.
      #
      # @return [String] For example, "J0".
      def memory_reference
        ["T#{value}", '00']
      end
    end
  end
end
