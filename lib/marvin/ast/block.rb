module Marvin
  module AST

    # A block containing many +Statement+ or +Expression+.
    class Block < Statement
      child :body, [Base]
    end
  end
end
