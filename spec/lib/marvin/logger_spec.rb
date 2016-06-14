require 'spec_helper'

describe Marvin::Logger do
  let(:logger) { Marvin::Logger.new }

  describe '.initialize' do
    it 'defaults to using $stdout' do
      expect(logger.stdout).to eql $stdout
    end

    it 'defaults to using $stderr' do
      expect(logger.stderr).to eql $stderr
    end
  end

  describe '#info' do
    context 'with verbose on' do
      it 'outputs the message to STDOUT' do
        expect { logger.info('foo') }.to output("foo\n").to_stdout
      end
    end

    context 'with verbose off' do
      before(:each) do
        Marvin.configuration.verbose = false
      end

      it 'does not output the message to STDOUT' do
        expect { logger.info('foo') }.to_not output.to_stdout
      end
    end

    it 'returns the text' do
      expect(logger.info('foo')).to eql 'foo'
    end
  end

  describe '#warning' do
    it 'stores the warning in an array' do
      logger.warning('foo')

      expect(logger.warnings).to include 'foo'
    end

    it 'returns the text' do
      expect(logger.warning('foo')).to eql 'foo'
    end
  end

  describe '#error' do
    it 'ouputs the message to STDOUT with formatting' do
      expect { logger.error('foo') }.to output(/foo/).to_stderr
    end

    it 'returns the text' do
      expect(logger.error('foo')).to eql 'foo'
    end
  end
end
