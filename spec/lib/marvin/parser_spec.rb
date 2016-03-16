require 'spec_helper'

describe Marvin::Parser do
  let(:tokens) { Marvin::Lexer.new(test_source).lex! }
  let(:parser) { Marvin::Parser.new(tokens) }

  describe '#parse!' do
    context 'with valid input' do
      it 'parses the input successfully' do
        expect(parser.parse!).to be_truthy
      end

      it 'creates a CST' do
        expect(parser.cst).to_not be_nil
      end
    end

    context 'with invalid input' do
      let(:bad_tokens) { Marvin::Lexer.new(bad_test_source).lex! }
      let(:bad_parser) { Marvin::Parser.new(bad_tokens) }

      it 'fail with a parse error' do
        expect { bad_parser.parse! }.to raise_error Marvin::Error::ParseError
      end
    end
  end
end
