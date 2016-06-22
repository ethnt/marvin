require 'spec_helper'

describe Marvin::Parser do
  let(:tokens) { Marvin::Lexer.new(test_source).lex }
  let(:parser) { Marvin::Parser.new(tokens) }

  describe '#parse' do
  end
end
