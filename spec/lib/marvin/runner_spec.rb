
require 'spec_helper'

describe Marvin::Runner do
  let(:runner) do
    runner = Marvin::Runner.new
    runner.source = File.read('./spec/fixtures/test-code-generation.txt')
    runner
  end

  # describe '.new' do
  #   it 'gives a valid instance' do
  #     expect(runner).to be_an_instance_of Marvin::Runner
  #   end
  #
  #   it 'has the default configuration' do
  #     expect(runner.config.logger).to be_an_instance_of Marvin::Logger
  #   end
  # end

  describe '#run!' do
    before do
      runner.run!
    end

    it 'outputs the correct code' do
      expect(runner.code.code).to eql "A9 00 8D 3D 00 A9 01 8D 3D 00 A9 00 8D 3E 00 A9 02 8D 3E 00 AC 3E 00 A2 01 FF A9 5B 8D 3F 00 A2 01 EC 3D 00 D0 07 AC 3F 00 A2 02 FF A9 55 8D 40 00 A9 4A 8D 3F 00 AC 3F 00 A2 02 FF 00 00 00 00 00 00 00 00 00 00 00 00 00 00 62 6C 61 63 6B 73 74 6F 6E 65 00 6A 61 6D 65 73 00 61 6C 61 6E 00"
    end
  end
end
