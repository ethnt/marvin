module Marvin
  class Lexer < RLTK::Lexer
    rule(/({)/)  { :T_LBRACKET }
    rule(/(})/)  { :T_RBRACKET }
    rule(/\(/)   { :T_LPAREN }
    rule(/\)/)   { :T_RPAREN }
    rule(/(\$)/) { :T_EOP }

    rule(/(int|string|boolean)/) { |t| [:T_TYPE, t] }
    rule(/(\d+)/) { |t| [:T_INTEGER, t.to_i] }
    rule(/(true|false)/) { |t| [:T_BOOLVAL, t == 'true'] }
    rule(/"([a-z\s]*?)"/) { |t| [:T_STRING, t] }
    rule(/([a-z])/) { |t| [:T_IDENT, t.to_sym] }

    rule(/(=)/) { |t| :T_ASSIGN }
    rule(/(==|!=)/) { |t| [:T_BOOLOP, t.to_sym] }
    rule(/(\+|-|\*|\/)/) { |t| [:T_INTOP, t.to_sym] }

    rule(/(print)/) { :T_PRINT }
    rule(/(if)/) { :T_IF }
    rule(/(while)/) { :T_WHILE }

    rule(/\s/)
  end
end
