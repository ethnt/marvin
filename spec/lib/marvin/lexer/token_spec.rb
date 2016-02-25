require 'spec_helper'

describe Marvin::Token do
  let(:token) { Marvin::Token.new('if', :if_statement, { line: 3, character: 4 }) }

  describe '#==' do
    let(:same) { Marvin::Token.new('if', :if_statement, { line: 3, character: 4 }) }
    let(:different) { Marvin::Token.new('f', :char, { line: 3, character: 4 }) }

    it 'will show the same Token as being the same' do
      expect(token == same).to be_truthy
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
