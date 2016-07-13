# rubocop:disable Metrics/LineLength, Metrics/ParameterLists

require 'rltk/parser'

module Marvin

  # This parser takes in a stream of tokens, verifies the input is correct, and
  # outputs an abstract syntax tree.
  class Parser < RLTK::Parser
    include ::Marvin::AST

    production(:program) do
      clause('statements') { |s| Program.new(s) }
    end

    list(:statements, 'statement')

    production(:statement) do
      clause('assign')     { |s| s }
      clause('function')   { |s| s }
      clause('print')      { |s| s }
      clause('if')         { |s| s }
      clause('expression') { |s| s }
    end

    production(:assign) do
      clause('T_IDENT T_ASSIGN expression') do |i, _, e|
        Assignment.new(i, e)
      end
    end

    production(:print) do
      clause('T_PRINT T_LPAREN expression T_RPAREN') do |_, _, e, _|
        Print.new(e)
      end
    end

    production(:if) do
      clause('T_IF T_LPAREN boolean T_RPAREN block') do |_, _, cond, _, body|
        If.new(cond, body)
      end
    end

    list(:arg_keys, :T_IDENT, :T_COMMA)

    production(:function) do
      clause('T_FUNCTION T_IDENT T_LPAREN arg_keys T_RPAREN block') do |_, name, _, args, _, body|
        Function.new(name, args, body)
      end
    end

    production(:expression) do
      clause('integer') { |i| i }
      clause('float') { |i| i }
      clause('boolean') { |i| i }
      clause('string') { |i| i }
      clause('arithmetic') { |i| i }
      clause('call') { |i| i }
    end

    production(:integer) do
      clause('T_INTEGER') { |i| Integer.new(i) }
    end

    production(:float) do
      clause('T_FLOAT') { |i| Float.new(i) }
    end

    production(:boolean) do
      clause('T_BOOLEAN') { |i| Boolean.new(i ? 1 : 0) }
    end

    production(:string) do
      clause('T_STRING') { |i| String.new(i) }
    end

    production('arithmetic') do
      clause('expression T_INTOP expression') do |left, op, right|
        case op
        when :+
          Addition.new(left, right)
        when :-
          Subtraction.new(left, right)
        when :*
          Multiplication.new(left, right)
        when :/
          Division.new(left, right)
        end
      end
    end

    list(:expression_list, 'expression', :T_COMMA)

    production(:arg_values) do
      clause('T_LPAREN expression_list T_RPAREN') { |_, e, _| e }
    end

    production('call') do
      clause('T_IDENT arg_values?') { |name, values| Call.new(name, values.to_a) }
    end

    production(:block) do
      clause('T_LBRACKET statements T_RBRACKET') { |_, s, _| Block.new(s) }
    end

    finalize lookahead: true
  end
end
