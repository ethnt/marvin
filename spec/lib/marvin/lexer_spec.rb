require 'spec_helper'

describe Marvin::Lexer do
  describe '.new' do
    let(:lexer) { Marvin::Lexer.new('{ } $') }

    it 'creates a new StringScanner with the input' do
      scanner = lexer.instance_variable_get(:@scanner)

      expect(scanner).to be_an_instance_of StringScanner
      expect(scanner.string).to eql '{ } $'
    end
  end

  describe '#lex' do
    it 'recognizes blocks' do
      tokens = get_lexemes('{ }')

      expect(tokens).to include '{'
      expect(tokens).to include '}'
    end

    it 'recognizes program ends' do
      tokens = get_lexemes('$')

      expect(tokens).to include '$'
    end

    it 'recognizes types' do
      tokens = get_lexemes('int string boolean')

      expect(tokens).to include 'int'
      expect(tokens).to include 'string'
      expect(tokens).to include 'boolean'
    end

    it 'recognizes digits' do
      tokens = get_lexemes('0 1 2 3 4 5 6 7 8 9')

      expect(tokens).to include '0'
      expect(tokens).to include '1'
      expect(tokens).to include '2'
      expect(tokens).to include '3'
      expect(tokens).to include '4'
      expect(tokens).to include '5'
      expect(tokens).to include '6'
      expect(tokens).to include '7'
      expect(tokens).to include '8'
      expect(tokens).to include '9'
    end

    it 'recognizes boolvals' do
      tokens = get_lexemes('true false')

      expect(tokens).to include 'true'
      expect(tokens).to include 'false'
    end

    it 'recognizes boolops' do
      tokens = get_lexemes('== !=')

      expect(tokens).to include '=='
      expect(tokens).to include '!='
    end

    it 'recognizes intops' do
      tokens = get_lexemes('+')

      expect(tokens).to include '+'
    end

    it 'recognizes strings' do
      tokens = get_lexemes("\"foo bar bar foo\"")

      expect(tokens).to include "\"foo bar bar foo\""
    end

    it 'recognizes print statements' do
      tokens = get_lexemes('print')

      expect(tokens).to include 'print'
    end

    it 'recognizes if statements' do
      tokens = get_lexemes('if')

      expect(tokens).to include 'if'
    end

    it 'recognizes while statements' do
      tokens = get_lexemes('while')

      expect(tokens).to include 'while'
    end

    it 'recognizes characters' do
      tokens = get_lexemes('a b c')

      expect(tokens).to include 'a'
      expect(tokens).to include 'b'
      expect(tokens).to include 'c'
    end

    it 'recognizes parenthesis' do
      tokens = get_lexemes('()')

      expect(tokens).to include '('
      expect(tokens).to include ')'
    end

    it 'throws an error for unrecognized characters' do
      expect { get_lexemes('ε') }.to raise_error SystemExit
    end
  end

  describe '#location_info' do
    let(:tokens) do
      lexer = Marvin::Lexer.new("{ }\n$")
      lexer.lex!
    end

    it 'correctly figures out lines and columns' do
      expect(tokens[0].attributes[:line]).to eql 1
      expect(tokens[0].attributes[:char]).to eql 0

      expect(tokens[1].attributes[:line]).to eql 1
      expect(tokens[1].attributes[:char]).to eql 2

      expect(tokens[2].attributes[:line]).to eql 2
      expect(tokens[2].attributes[:char]).to eql 1
    end
  end

  def get_lexemes(str)
    Marvin::Lexer.new(str).lex!.map(&:lexeme)
  end
end
