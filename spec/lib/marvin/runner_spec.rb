require 'spec_helper'

describe Marvin::Runner do
  before(:each) do
    # allow(Kernel).to receive(:exit)
  end

  let(:runner) do
    runner = Marvin::Runner.new
    runner.code = 'foobar'
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
    context 'without source code' do
      let(:no_code) { Marvin::Runner.new }

      it 'raises an exception' do
        expect { no_code.run! }.to raise_error(ArgumentError)
      end
    end
  end
end
