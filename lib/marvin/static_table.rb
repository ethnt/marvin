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
    # @param [Marvin::Production] production The variable declaration production.
    # @return [Marvin::StaticTable::Entry] The entry in the static table.
    def add_entry(production)
      type = production.children.first.content
      identifier = production.children.last.content

      next_value = if @entries.empty?
                     0
                   else
                     @entries.map(&:value).max + 1
                   end

      entry = Entry.new(
        value: next_value,
        name: identifier.lexeme,
        scope: identifier.attributes[:scope],
        type: type.lexeme
      )

      @entries << entry

      entry
    end

    # Get an entry from the jump table.
    #
    # @param [Integer] name The identifier name in the static table.
    # @param [Integer] scope The scope to filter by.
    # @return [Marvin::StaticTable::Entry] The entry in the static table.
    def get_entry(name, scope: nil)
      results = @entries.select { |e| e.name == name }

      return results.first unless scope

      results.find { |e| e.scope == scope }
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

      # The type of the identifier. Defaults to nil.
      property :type, default: nil

      # Return the jump reference.
      #
      # @return [String] For example, "J0".
      def memory_reference
        ["T#{value}", 'XX']
      end
    end
  end
end
