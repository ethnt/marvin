require 'spec_helper'

describe Marvin::Configuration do
  describe '#logger' do
    it 'defaults to Marvin::Logger' do
      # rubocop:disable Metrics/LineLength
      expect(Marvin::Configuration.new.logger).to be_an_instance_of Marvin::Logger
    end
  end

  describe '#logger=' do
    it 'sets the value for the logger' do
      config = Marvin::Configuration.new
      config.logger = STDERR

      expect(config.logger).to eql STDERR
    end
  end
end
