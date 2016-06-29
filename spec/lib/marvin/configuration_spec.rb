require 'spec_helper'

describe Marvin::Configuration do
  let(:default) { Marvin::Configuration.new }

  describe '#logger' do
    it 'defaults to Marvin::Logger' do
      expect(default.logger).to be_an_instance_of Marvin::Logger
    end
  end

  describe '#logger=' do
    it 'sets the value for the logger' do
      config = Marvin::Configuration.new
      config.logger = STDERR

      expect(config.logger).to eql STDERR
    end
  end

  describe '#verbose' do
    it 'defaults to false' do
      expect(default.verbose).to eql false
    end
  end

  describe '#verbose=' do
    it 'sets the value for verboseness' do
      config = Marvin::Configuration.new
      config.verbose = true

      expect(config.verbose).to eql true
    end
  end
end
