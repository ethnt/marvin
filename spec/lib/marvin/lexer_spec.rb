require 'spec_helper'

describe Marvin::Lexer do
  it 'inherits from RLTK::Lexer' do
    expect(subject).to be_a RLTK::Lexer
  end

  describe '#lex' do
    it 'recognizes parenthesis' do
      types = get_types('( )')

      expect(types).to eql [:T_LPAREN, :T_RPAREN]
    end

    it 'recognizes brackets' do
      types = get_types('{ }')

      expect(types).to eql [:T_LBRACKET, :T_RBRACKET]
    end

    it 'recognizes assignments' do
      types = get_types('=')

      expect(types).to eql [:T_ASSIGN]
    end

    it 'recognizes commas' do
      types = get_types(',')

      expect(types).to eql [:T_COMMA]
    end

    it 'recognizes integers' do
      types = get_types('0 1 2 3 4 5 6 7 8 9')

      expect(types).to eql [:T_INTEGER]
    end

    it 'recognizes floats' do
      types = get_types('0.0 1.1 2.2 3.3 4.4 5.5 6.6 7.7 8.8 9.9')

      expect(types).to eql [:T_FLOAT]
    end

    it 'recognizes booleans' do
      types = get_types('true false')

      expect(types).to eql [:T_BOOLEAN]
    end

    it 'recognizes strings' do
      types = get_types('"foo"')

      expect(types).to eql [:T_STRING]
    end

    it 'recognizes identifiers' do
      types = get_types('foo')

      expect(types).to eql [:T_IDENT]
    end

    it 'recognizes integer operations' do
      types = get_types('+ - * /')

      expect(types).to eql [:T_INTOP]
    end

    it 'recognizes boolean operations' do
      types = get_types('== != > <')

      expect(types).to eql [:T_BOOLOP]
    end

    it 'recognizes print' do
      types = get_types('print')

      expect(types).to eql [:T_PRINT]
    end

    it 'recognizes if' do
      types = get_types('if')

      expect(types).to eql [:T_IF]
    end

    it 'recognizes else' do
      types = get_types('else')

      expect(types).to eql [:T_ELSE]
    end

    it 'recognizes functions' do
      types = get_types('fun')

      expect(types).to eql [:T_FUNCTION]
    end

    it 'recognizes returns' do
      types = get_types('return')

      expect(types).to eql [:T_RETURN]
    end

    it 'does nothing with spaces and newlines' do
      types = get_types(" \n")

      expect(types).to eql []
    end
  end

  def get_types(str)
    Marvin::Lexer.lex(str).map(&:type).reject { |t| t == :EOS }.uniq
  end
end
