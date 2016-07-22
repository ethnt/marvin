# frozen_string_literal: true

require 'rcgtk/llvm'
require 'rcgtk/contractor'
require 'rcgtk/module'

module Marvin

  # Initialize LLVM to an x86 architecture.
  RCGTK::LLVM.init(:X86)

  # The contractor generates the LLVM intermediate representation (IR).
  class Contractor < RCGTK::Contractor

    # The RCGTK module for building the LLVM IR.
    attr_reader :module

    # Creates a new contractor. Initialize the LLVM module.
    #
    # @return [Marvin::Contractor] A shiny new contractor.
    def initialize
      super

      @module = RCGTK::Module.new('Marvin JIT')
      @st     = {}

      self
    end
  end
end