require 'spec_helper'

describe Marvin::Lexer do
  describe '#lex' do
    it 'recognizes blocks' do
      types = get_types('{ }')

      expect(types).to eql [:T_LBRACKET, :T_RBRACKET]
    end

    it 'recognizes program ends' do
      types = get_types('$')

      expect(types).to eql [:T_EOP]
    end

    it 'recognizes types' do
      types = get_types('int string boolean')

      expect(types).to eql [:T_TYPE]
    end

    it 'recognizes digits' do
      types = get_types('0 1 2 3 4 5 6 7 8 9')

      expect(types).to eql [:T_INTEGER]
    end

    it 'recognizes boolvals' do
      types = get_types('true false')

      expect(types).to eql [:T_BOOLVAL]
    end

    it 'recognizes boolops' do
      types = get_types('== !=')

      expect(types).to eql [:T_BOOLOP]
    end

    it 'recognizes intops' do
      types = get_types('+ -')

      expect(types).to eql [:T_INTOP]
    end

    it 'recognizes strings' do
      types = get_types("\"foo bar bar foo\"")

      expect(types).to eql [:T_STRING]
    end

    it 'recognizes print statements' do
      types = get_types('print')

      expect(types).to eql [:T_PRINT]
    end

    it 'recognizes if statements' do
      types = get_types('if')

      expect(types).to eql [:T_IF]
    end

    it 'recognizes while statements' do
      types = get_types('while')

      expect(types).to eql [:T_WHILE]
    end

    it 'recognizes identifiers' do
      types = get_types('a b c').uniq

      expect(types).to eql [:T_IDENT]
    end

    it 'recognizes parenthesis' do
      types = get_types('()')

      expect(types).to eql [:T_LPAREN, :T_RPAREN]
    end

    it 'throws an error for unrecognized characters'
  end

  def get_types(str)
    Marvin::Lexer.lex(str).map(&:type).reject { |t| t == :EOS }.uniq
  end
end
