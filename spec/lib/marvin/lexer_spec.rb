require 'spec_helper'

describe Marvin::Lexer do
  let(:lexer) { Marvin::Lexer.new('{ } $') }

  describe '.new' do
    it 'creates an empty Array of tokens' do
      expect(lexer.tokens).to eql []
    end
  end

  describe '#lex!' do
    before do
      lexer.lex!
    end

    it 'creates some tokens' do
      result = [
        :block_begin,
        :block_end,
        :program_end
      ]

      expect(lexer.tokens.collect(&:kind)).to eql result
    end
  end
end
