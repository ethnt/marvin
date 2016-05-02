module Marvin

  # Represents a 6502a instruction set (stack and heap).
  class InstructionSet
    # Creates a new instruction set.
    #
    # @return [Marvin::InstructionSet] Empty instructions.
    def initialize
      @stack = []
      @heap = []
    end

    def code
      @stack + @heap
    end

    # Adds to the stack (the front).
    #
    # @param [Array] instructions An array of instructions (e.g., +['AD', '09']).
    # @return [Array] The resulting code.
    def add_to_stack(instructions)
      @stack += [instructions].flatten

      ensure_size!

      code
    end

    # Adds to the heap (the back).
    #
    # @param [Array] instructions An array of instructions (e.g., +['AD', '09']).
    # @return [Array] The resulting code.
    def add_to_heap(instructions)
      @heap = [instructions].flatten + @heap

      ensure_size!

      code
    end

    private

    def ensure_size!
      return Marvin::InstructionSpaceError.new if code.length > 96
    end
  end
end
