# frozen_string_literal: true

module Marvin
  module AST

    # An if statement with a test and a body.
    class If < Statement
      child :test, Test
      child :body, Block
    end
  end
end
