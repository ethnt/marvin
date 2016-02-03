require 'spec_helper'

describe Marvin::Logger do
  let(:logger) { Marvin::Logger.new }

  describe '.initialize' do
    it 'defaults to using $stdout' do
      expect(logger.destination).to eql $stdout
    end
  end

  describe '#warning' do
    let(:warning) { logger.warning('foo') }

    it 'outputs to $stdout' do
      expect { warning }.to output("warning: foo\n").to_stdout
    end

    it 'logs the warning' do
      expect(logger.warnings).to include warning
    end
  end

  describe '#error' do
    let(:error) { logger.error('foo') }

    it 'outputs to $stdout' do
      expect { error }.to output("error: foo\n").to_stdout
    end

    it 'logs the error' do
      expect(logger.errors).to include error
    end
  end
end
