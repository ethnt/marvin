require 'spec_helper'

describe Marvin::Lexer do
  describe '#lex' do
    it 'recognizes blocks' do
      kinds = get_kinds('{ }')

      expect(kinds).to eql [:T_LBRACKET, :T_RBRACKET]
    end

    it 'recognizes program ends' do
      kinds = get_kinds('$')

      expect(kinds).to eql [:T_EOP]
    end

    it 'recognizes types' do
      kinds = get_kinds('int string boolean')

      expect(kinds).to eql [:T_TYPE]
    end

    it 'recognizes digits' do
      kinds = get_kinds('0 1 2 3 4 5 6 7 8 9')

      expect(kinds).to eql [:T_INTEGER]
    end

    it 'recognizes boolvals' do
      kinds = get_kinds('true false')

      expect(kinds).to eql [:T_BOOLVAL]
    end

    it 'recognizes boolops' do
      kinds = get_kinds('== !=')

      expect(kinds).to eql [:T_BOOLOP]
    end

    it 'recognizes intops' do
      kinds = get_kinds('+ -')

      expect(kinds).to eql [:T_INTOP]
    end

    it 'recognizes strings' do
      kinds = get_kinds("\"foo bar bar foo\"")

      expect(kinds).to eql [:T_STRING]
    end

    it 'recognizes print statements' do
      kinds = get_kinds('print')

      expect(kinds).to eql [:T_PRINT]
    end

    it 'recognizes if statements' do
      kinds = get_kinds('if')

      expect(kinds).to eql [:T_IF]
    end

    it 'recognizes while statements' do
      kinds = get_kinds('while')

      expect(kinds).to eql [:T_WHILE]
    end

    it 'recognizes identifiers' do
      kinds = get_kinds('a b c').uniq

      expect(kinds).to eql [:T_IDENT]
    end

    it 'recognizes parenthesis' do
      kinds = get_kinds('()')

      expect(kinds).to eql [:T_LPAREN, :T_RPAREN]
    end

    it 'throws an error for unrecognized characters'
  end

  def get_kinds(str)
    Marvin::Lexer.new(str).lex.map(&:kind).uniq
  end

  def get_lexemes(str)
    Marvin::Lexer.new(str).lex.map(&:lexeme)
  end
end
