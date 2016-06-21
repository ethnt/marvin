require 'spec_helper'

describe Marvin::Runner do
  let(:runner) do
    runner = Marvin::Runner.new
    runner.source = File.read('./spec/fixtures/test-code-generation.txt')
    runner
  end

  describe '#initialize' do
    it 'sets the source' do
      expect(runner.source).to eql File.read('./spec/fixtures/test-code-generation.txt')
    end
  end

  describe '#run!' do
    before do
      runner.run!
    end

    it 'splits up the programs' do
      runner = Marvin::Runner.new
      runner.source = File.read('./spec/fixtures/test-multiple-programs.txt')
      runner.run!

      expect($stdout.string).to include 'Compiling program #0'
      expect($stdout.string).to include 'Compiling program #1'
    end

    it 'runs the lexer' do
      expect(runner.lexer).to_not be_nil
    end

    it 'runs the parser' do
      expect(runner.parser).to_not be_nil
    end

    it 'runs the code generator' do
      expect(runner.code).to_not be_nil
    end

    it 'outputs code' do
      expect($stdout.string).to include 'A9 00 8D 30 00 A9 01 8D'
    end

    it 'outputs warnings' do
      runner = Marvin::Runner.new
      runner.source = File.read('./spec/fixtures/test-warning.txt')
      runner.run!

      expect($stdout.string).to include 'warning'
    end

    it 'returns itself' do
      expect(runner.run!).to eql runner
    end
  end
end
