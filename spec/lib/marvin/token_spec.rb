require 'spec_helper'

describe Marvin::Token do
  let(:token) { Marvin::Token.new(:T_IF, 'if') }

  describe '#==' do
    let(:different) { Marvin::Token.new(:T_FOO, 'foo') }

    it 'will show the same Token as being the same' do
      expect(token == token).to be_truthy
    end

    it 'will show a different Token as being different' do
      expect(token == different).to be_falsey
    end
  end

  describe '#to_s' do
    it 'will output Tokens in the standard way' do
      expect(token.to_s).to eql '<Token T_IF : "if">'
    end
  end

  describe '#to_a' do
    it 'will output an array with kind first, lexeme second' do
      expect(token.to_a).to eql [:T_IF, 'if']
    end
  end
end
