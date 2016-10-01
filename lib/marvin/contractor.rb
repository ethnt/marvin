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
    def add(ast)
      visit(ast)
    end

    on Marvin::AST::Program do |node|
      node.contents.each do |subnode|
        visit(subnode)
      end
    end

    on Marvin::AST::Function do |node|
      fun = @module.functions[node.name.to_s]

      if fun
        fail "Redefinition of function '#{node.name}'."
      elsif fun && fun.params.size != node.parameters.length
        fail "Redefinition of function '#{node.name}' with a different number of parameters."
      else
        # FIXME: The `Array.new` business is just setting the return types and
        # parameter types to DoubleTypes. Maybe don't do that.
        fun = @module.functions.add(node.name.to_sym, RCGTK::FloatType, Array.new(node.parameters.length, RCGTK::FloatType))
      end

      # Set all of the parameters in the symbol table
      fun.tap do
        node.parameters.each_with_index do |name, i|
          (@st[name.to_s] = fun.params[i]).name = name.to_s
        end
      end

      # Reset the symbol table
      # @st.clear

      # Create a new basic block to insert into, translate the expression, and
      # set its value as the return value
      ret((visit(node.body.body.first, at: fun.blocks.append('entry'))))

      # Verify the function and return it
      fun.tap { fun.verify }
    end

    on Marvin::AST::Block do |node|
      node.body.each do |subnode|
        visit(subnode)
      end
    end

    on Marvin::AST::Call do |node|
      # FIXME: This shouldn't be like this. Maybe separate out variable and
      # function calls in the AST?
      #
      # If there's no arguments, it's a variable call
      if node.arguments.empty?
        if @st.key?(node.name.to_s)
          @str[node.name.to_s]
        else
          fail "Uninitialized variable '#{node.name.to_s}'."
        end

      # If there are arugments, it's a function call
      else
        # Get the registered function by name
        callee = @module.functions[node.name.to_s]

        # If there's no function defined by that name, fail
        if not callee
          fail "Unknown function '#{node.name.to_s}' referenced."
        end

        # If there's a mismatch in parameter/argument numbers, fail
        if callee.params.size != node.arguments.length
          fail "Function '#{node.name.to_s}' expected #{callee.params.size} argument(s) but was called with #{node.arguments.size}."
        end

        arguments = node.arguments.map { |arg| visit(arg) }

        call(callee, *arguments.push('calltmp'))
      end
    end

    on Marvin::AST::Float do |node|
      RCGTK::Float.new(node.value)
    end
  end
end
