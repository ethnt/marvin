require 'spec_helper'

describe Marvin do
  it 'provides a version' do
    expect(Marvin::VERSION).to_not be_nil
  end

  describe '.configuration' do
    it 'returns the same object every time' do
      expect(Marvin.configuration).to eql Marvin.configuration
    end
  end

  describe '.configuration=' do
    it 'sets the configuration' do
      configuration = Marvin::Configuration.new
      configuration.verbose = true

      Marvin.configuration = configuration

      expect(Marvin.configuration).to eql configuration
    end
  end

  describe '.configure' do
    it 'yields the current configuration' do
      Marvin.configure do |config|
        expect(config).to eql Marvin.configuration
      end
    end
  end

  describe '.logger' do
    it 'returns the configuration logger' do
      expect(Marvin.logger).to eql Marvin.configuration.logger
    end
  end
end
