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
    # @param [Marvin::Token] token The token of the identifier reference.
    # @return [Marvin::StaticTable::Entry] The entry in the static table.
    def add_entry(token)
      next_value = if @entries.empty?
                     0
                   else
                     @entries.map(&:value).max + 1
                   end

      entry = Entry.new(
        value: next_value,
        name: token.lexeme,
        scope: token.attributes[:scope]
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

      # The scope. Defaults to nil.
      property :scope, default: nil

      # The offset. Defaults to nil.
      property :offset, default: nil

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
