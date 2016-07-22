require 'spec_helper'

describe Marvin::Contractor do
  let(:contractor) { Marvin::Contractor.new }

  describe '#initialize' do

    it 'returns instance of itself' do
      expect(contractor).to be_a Marvin::Contractor
    end

    it 'creates a LLVM module' do
      expect(contractor.module).to be_a RCGTK::Module
    end
  end
end
