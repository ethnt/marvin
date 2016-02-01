require 'spec_helper'

describe Marvin::Runner do
  let(:runner) { Marvin::Runner.new('foobar', {}) }

  describe '.new' do
    it 'gives a valid instance' do
      expect(runner).to be_an_instance_of Marvin::Runner
    end
  end

  describe '#config' do
    it 'has the default configuration' do
      expect(runner.config.logger).to eql STDOUT
    end
  end
end
