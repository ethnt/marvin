require 'spec_helper'

describe Marvin::Logger do
  let(:logger) { Marvin::Logger.new($stdout, true) }

  describe '.initialize' do
    it 'defaults to using $stdout' do
      expect(logger.destination).to eql $stdout
    end
  end

  describe '#info' do
    let(:info) { logger.info('foo') }

    it 'outputs to $stdout' do
      expect { info }.to output("foo\n").to_stdout
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
end
