require 'spec_helper'

describe Marvin::Runner do
  let(:runner) { Marvin::Runner.new }

  describe '.new' do
    it 'gives a valid instance' do
      expect(runner).to be_an_instance_of Marvin::Runner
    end

    it 'has the default configuration' do
      expect(runner.config.logger).to be_an_instance_of Yell::Logger
    end
  end

  describe '#run!' do
    it 'compiles'
  end
end
