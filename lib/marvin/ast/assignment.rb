module Marvin
  module AST

    # Assigning a value to a variable.
    class Assignment < Statement
      value :name, Symbol
      child :value, Expression
    end
  end
end
