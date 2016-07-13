# frozen_string_literal: true

module Marvin
  module AST

    # A program is the source file with a list of statements.
    class Program < Expression
      value :contents, [Base]
    end
  end
end
