module Marvin
  class JumpTable

    def initialize
      @entries = []
    end

    # Add a new entry.
    #
    # @param [Marvin::Identifier] identifier The identifier to add.
    # @return [Hash] The entry in the static table.
    def add_entry(name)
      entry = {
        temporary_value: next_temporary_value!,
        distance: nil
      }

      @entries << entry

      entry
    end

    def get_entry(value)
      @entries.find { |e| e.temporary_value == value }
    end

    private

    def next_temporary_address!
      return 0 if @entries.empty?

      @entries.map { |e| e[:temporary_value] }.max + 1
    end
  end
end
