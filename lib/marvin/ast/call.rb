# frozen_string_literal: true

module Marvin
  module AST

    # Represents a call of a variable or function.
    class Call < Expression
      value :name, Symbol
      child :arguments, [Expression]
    end
  end
end
