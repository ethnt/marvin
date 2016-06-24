module Marvin
  class Parser < RLTK::Parser
    production(:program) do
      clause('.block T_EOP') { |b| b }
    end

    production(:block) do
      clause('T_LBRACKET T_RBRACKET') { |_,_| }
    end

    finalize
  end
end
