# frozen_string_literal: true

require 'rltk/ast'

require_relative 'ast/base'

require_relative 'ast/expression'
require_relative 'ast/integer'
require_relative 'ast/float'
require_relative 'ast/boolean'
require_relative 'ast/string'
require_relative 'ast/arithmetic'
require_relative 'ast/addition'
require_relative 'ast/subtraction'
require_relative 'ast/multiplication'
require_relative 'ast/division'

require_relative 'ast/statement'
require_relative 'ast/block'
require_relative 'ast/assignment'
require_relative 'ast/print'
require_relative 'ast/if'
require_relative 'ast/function'
require_relative 'ast/call'

require_relative 'ast/program'

module Marvin

  # Contains the nodes for the abstract syntax tree.
  module AST
  end
end
