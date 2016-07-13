module Marvin
  module AST

    # An if statement with a test and a body.
    class If < Statement
      child :test, Boolean
      child :body, Block
    end
  end
end
