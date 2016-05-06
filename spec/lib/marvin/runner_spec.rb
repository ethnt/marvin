
require 'spec_helper'

describe Marvin::Runner do
  let(:runner) do
    runner = Marvin::Runner.new
    runner.source = File.read('./spec/fixtures/test-code-generation.txt')
    runner
  end

  describe '.new' do
    it 'gives a valid instance' do
      expect(runner).to be_an_instance_of Marvin::Runner
    end

    it 'has the default configuration' do
      expect(runner.config.logger).to be_an_instance_of Marvin::Logger
    end
  end

  describe '#run!' do
    before do
      runner.run!
    end

    it 'creates a new Lexer' do
      expect(runner.lexer).to be_an_instance_of Marvin::Lexer
    end

    it 'outputs the correct code' do
      expect(runner.code.code).to eql "A9 00 8D 2F 00 A9 03 8D 2F 00 A9 00 8D 30 00 A9 04 8D 30 00 AD 30 00 8D 2F 00 AC 2F 00 A2 01 FF AE 2F 00 EC 30 00 D0 07 AC 2F 00 A2 01 FF 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00"
    end
  end
end
