# frozen_string_literal: true

module Marvin
  module AST

    # A print statement with an expression body.
    class Print < Statement
      value :body, Expression
    end
  end
end
