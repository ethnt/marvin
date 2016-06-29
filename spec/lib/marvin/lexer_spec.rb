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

    it 'recognizes integers' do
      types = get_types('0 1 2 3 4 5 6 7 8 9')

      expect(types).to eql [:T_INTEGER]
    end

    it 'recognizes print' do
      types = get_types('print')

      expect(types).to eql [:T_PRINT]
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
