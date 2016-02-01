require 'spec_helper'

describe Marvin::Base do
  let(:base) { Marvin::Base.new('foobar', {}) }

  describe '.new' do
    it 'gives a valid instance' do
      expect(base).to be_an_instance_of Marvin::Base
    end
  end

  describe '#config' do
    it 'has the default configuration' do
      expect(base.config.logger).to eql STDOUT
    end
  end
end
