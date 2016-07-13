module Marvin
  module AST

    # For representing function definitions.
    class Function < Statement
      value :name, Symbol
      value :parameters, [Symbol]
      child :body, Block
    end
  end
end
