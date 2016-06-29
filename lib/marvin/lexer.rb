require 'rltk/lexer'

module Marvin

  # This lexer will take in the source input and break it up into tokens.
  class Lexer < RLTK::Lexer
    rule(/\(/)      { :T_LPAREN }
    rule(/\)/)      { :T_RPAREN }

    rule(/(\d+)/)   { :T_INTEGER }

    rule(/(print)/) { :T_PRINT }
    
    rule(/\s/)
  end
end
