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

    # Adds a node to the IR.
    #
    # @param [RLTK::AST::Node] node An AST node.
    # @return [NilClass]
    def add(node)
      case node
      when Marvin::AST::Program
        visit(Marvin::AST::Function.new(:'', [], node.contents))
      when Marvin::AST::Statement, Marvin::AST::Expression
        visit(Marvin::AST::Function.new(:'', [], node))
      when Marvin::AST::Function, Marvin::AST::Call
        visit(ast)
      else
        fail 'Attempting to add unhandled node type to JIT.'
      end
    end

    # Handles functions.
    on Marvin::AST::Function do |node|
      # Clear the symbol table
      @st.clear

      # Let's build the prototype
      if fun = @module.functions[node.name]
        if fun.body.body.size != 0
          fail "Redefinition of function #{node.name}"
        elsif fun.parameters.size != node.arguments.length
          fail "Redefinition of function #{node.name} with different number of arguments"
        end
      else
        fun = @module.functions.add(node.name, RCGTK::DoubleType, Array.new(node.arguments.length, RCGTK::DoubleType))
      end

      fun = fun.tap do
        node.arguments.each_with_index do |name, i|
          (@st[name] = fun.params[i]).name = name
        end
      end

      ret (visit node.body, at: fun.blocks.append('entry'))

      fun.tap { fun.verify }
    end

    on Marvin::AST::Call do |node|
      if node.arguments.length > 0
        callee = @module.functions[node.name]

        if not callee
          fail 'Unknown function referenced'
        end

        if callee.parameters.size != node.arguments.length
          fail "Function #{node.name} expected #{callee.parameters.size} arguments but was called with #{node.arguments.length}"
        end

        args = node.args.map { |arg| visit arg }

        call callee, *args.push('calltmp')
      else
        if @st.key?(node.name)
          @st[node.name]
        else
          fail "Uninitialized variable #{node.name}"
        end
      end
    end
  end
end
