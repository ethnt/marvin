# frozen_string_literal: true

module Marvin
  module AST

    # Parent class for any arithmetic. Operator is determined by the class
    # (+Addition+, etc).
    class Arithmetic < Expression
      child :left, Expression
      child :right, Expression
    end
  end
end
