require 'spec_helper'

describe Marvin::Logger do
  let(:logger) { Marvin::Logger.new }

  # describe '.initialize' do
  #   it 'defaults to using $stdout' do
  #     expect(logger.stdout).to eql $stdout
  #   end
  # end
  #
  # describe '#info' do
  #   let(:info) { logger.info('foo') }
  #
  #   it 'outputs to $stdout' do
  #     # expect { info }.to output("foo\n").to_stdout
  #   end
  # end
  #
  # describe '#warning' do
  #   let(:warning) { logger.warning('foo') }
  #
  #   it 'logs the warning' do
  #     expect(logger.warnings).to include warning
  #   end
  # end
end
