require 'spec_helper'

describe Marvin::Token do
  let(:token) do
    Marvin::Token.new(
      lexeme: 'if',
      kind: :if_statement,
      attributes: { line: 3, character: 4 }
    )
  end

  describe '#==' do
    let(:different) do
      Marvin::Token.new(
        lexeme: 'f',
        kind: :char,
        attributes: { line: 3, character: 4 }
      )
    end

    it 'will show the same Token as being the same' do
      expect(token == token).to be_truthy
    end

    it 'will show a different Token as being different' do
      expect(token == different).to be_falsey
    end
  end

  describe '#to_s' do
    it 'will output Tokens in the standard way' do
      expect(token.to_s).to eql '<Token if_statement : "if">'
    end
  end
end
