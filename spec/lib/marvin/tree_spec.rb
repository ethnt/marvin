require 'spec_helper'

describe Marvin::Tree do
  let(:tree) { Marvin::Tree.new(Marvin::Node.new('root')) }

  describe '#initialize' do
    it 'has a root node' do
      expect(tree.root).to eql Marvin::Node.new('root')
    end
  end
end
