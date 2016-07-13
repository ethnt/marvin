# frozen_string_literal: true

module Marvin
  module AST

    # An string (e.g., +"foobar"+, etc).
    class String < Expression
      value :value, ::String
    end
  end
end
