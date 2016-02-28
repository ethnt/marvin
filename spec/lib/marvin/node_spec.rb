require 'spec_helper'

describe Marvin::Node do
  let(:node) { Marvin::Node.new(2) }

  describe '#initialize' do
    it 'sets the data' do
      expect(node.data).to eql 2
    end

    it 'sets the parent to nil' do
      expect(node.parent).to eql nil
    end

    it 'sets the children to an empty array' do
      expect(node.children).to eql []
    end
  end

  describe '#each' do
    it 'allows to run a block over every parent and child element' do
      node.parent = Marvin::Node.new(1)
      node.children = [
        Marvin::Node.new(3),
        Marvin::Node.new(4)
      ]

      # Enumerable implements a bunch of different methods, including #collect.
      expect(node.collect(&:data)).to eql [1, 2, 3, 4]
    end
  end

  describe '#<=>' do
    it 'returns nil for a non-Node argument' do
      expect(node <=> Object.new).to eql nil
    end

    it 'returns 0 for the same node' do
      equivalent = Marvin::Node.new(2)

      expect(node <=> equivalent).to eql 0
    end
  end

  describe '#eql?' do
    let(:other_node) { Marvin::Node.new(2) }

    it 'returns true for the same node' do
      expect(node.eql?(other_node)).to eql true
    end
  end
end
