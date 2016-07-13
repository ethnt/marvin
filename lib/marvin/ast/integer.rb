# frozen_string_literal: true

module Marvin
  module AST

    # An integer (e.g., +0+, +1+, etc).
    class Integer < Expression
      value :value, ::Fixnum
    end
  end
end
