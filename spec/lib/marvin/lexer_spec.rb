require 'spec_helper'

describe Marvin::Lexer do
  let(:lexer) { Marvin::Lexer.new(test_source) }

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
        :type,
        :char,
        :assignment,
        :digit,
        :intop,
        :digit,
        :type,
        :char,
        :char,
        :char,
        :assignment,
        :boolval,
        :while,
        :open_parenthesis,
        :char,
        :boolop,
        :boolval,
        :close_parenthesis,
        :block_begin,
        :if_statement,
        :open_parenthesis,
        :char,
        :boolop,
        :boolval,
        :close_parenthesis,
        :block_begin,
        :print,
        :open_parenthesis,
        :string,
        :close_parenthesis,
        :block_end,
        :else_statement,
        :block_begin,
        :print,
        :open_parenthesis,
        :string,
        :close_parenthesis,
        :block_end,
        :block_end,
        :block_end,
        :program_end
      ]

      expect(lexer.tokens.collect(&:kind)).to eql result
    end
  end
end
