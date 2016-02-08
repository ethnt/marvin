require 'spec_helper'

describe Marvin::Token do
  let(:token) { Marvin::Token.new('if', :reserved, { line: 3, character: 4 }) }

  it 'creates a unique hex value' do
    expect(token.hex).to_not be_nil
  end

  describe '#==' do
    let(:same) { Marvin::Token.new('if', :reserved, { line: 3, character: 4 }) }
    let(:different) { Marvin::Token.new('f', :variable, { line: 3, character: 4 }) }

    it 'will show the same Token as being the same' do
      expect(token == same).to be_truthy
    end

    it 'will show a different Token as being different' do
      expect(token == different).to be_falsey
    end
  end
end
