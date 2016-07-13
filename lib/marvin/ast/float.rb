module Marvin
  module AST

    # For floats (+1.0+, +3.14159+, etc).
    class Float < Expression
      value :value, ::Float
    end
  end
end
