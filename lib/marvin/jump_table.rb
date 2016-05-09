module Marvin

  # A jump table includes jump values and the distance to jump when branching
  # in operation codes.
  class JumpTable
    attr_accessor :entries

    # Creates a new jump table. Has no entries.
    #
    # @return [Marvin::JumpTable] A new jump table.
    def initialize
      @entries = []
    end

    # Add a new entry.
    #
    # @return [Marvin::JumpTable::Entry] The entry in the jump table.
    def add_entry
      next_value = if @entries.empty?
                     0
                   else
                     @entries.map(&:value).max + 1
                   end

      entry = Entry.new(
        value: next_value
      )

      @entries << entry

      entry
    end

    # Get an entry from the jump table.
    #
    # @param [Integer] value The number in the jump table (i.e., 0 from "J0").
    # @return [Marvin::JumpTable::Entry] The entry in the jump table.
    def get_entry(value)
      @entries.find { |e| e.value == value }
    end

    # A basic entry in a jump table. Includes the value (i.e., 0) and the
    # distance to jump.
    class Entry < Hashie::Dash

      # The value (i.e., the 0 from "J0").
      property :value

      # The distance to jump. Defaults to nil.
      property :distance, default: nil

      # Return the jump reference.
      #
      # @return [String] For example, "J0".
      def jump_reference
        "J#{value}"
      end
    end
  end
end
