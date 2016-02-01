require 'spec_helper'

describe Marvin::Configuration do
  describe '#logger' do
    it 'defaults to STDOUT' do
      expect(Marvin::Configuration.new.logger).to eql STDOUT
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
