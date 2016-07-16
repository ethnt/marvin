# frozen_string_literal: true

require 'rltk/lexer'

module Marvin

  # This lexer will take in the source input and break it up into tokens.
  class Lexer < RLTK::Lexer
    rule(/\(/)            { :T_LPAREN }
    rule(/\)/)            { :T_RPAREN }
    rule(/\{/)            { :T_LBRACKET }
    rule(/\}/)            { :T_RBRACKET }
    rule(/(=)/)           { :T_ASSIGN }
    rule(/(,)/)           { :T_COMMA }

    rule(%r{(\+|-|\*|/)}) { |t| [:T_INTOP, t.to_sym] }
    rule(/(==|!=|<|>)/)   { |t| [:T_BOOLOP, t.to_sym] }

    rule(/(print)/)       { :T_PRINT }
    rule(/(if)/)          { :T_IF }
    rule(/(else)/)        { :T_ELSE }
    rule(/(fun)/)         { :T_FUNCTION }
    rule(/(return)/)      { :T_RETURN }

    rule(/(\d+)/)         { |t| [:T_INTEGER, t.to_i] }
    rule(/(\d+\.\d+)/)    { |t| [:T_FLOAT,   t.to_f] }
    rule(/(true|false)/)  { |t| [:T_BOOLEAN, t == 'true'] }
    rule(/"([a-z\s]*?)"/) { |t| [:T_STRING,  t] }
    rule(/([a-z]+)/)      { |t| [:T_IDENT,   t.to_sym] }
    rule(/\s/)
  end
end
