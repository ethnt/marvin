# frozen_string_literal: true

module Marvin
  module AST

    # Parent class for any test. Operator is determined by the class
    # (+Equals+, +NotEquals+, etc).
    class Test < Expression
      child :left, Expression
      child :right, Expression
    end
  end
end
