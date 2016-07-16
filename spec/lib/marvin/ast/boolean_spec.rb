require 'spec_helper'

describe Marvin::AST::Boolean do
  let(:true_node) do
    Marvin::AST::Boolean.new(1)
  end

  let(:false_node) do
    Marvin::AST::Boolean.new(0)
  end

  it 'inherits from Marvin::AST::Expression' do
    expect(true_node).to be_a Marvin::AST::Expression
    expect(false_node).to be_a Marvin::AST::Expression
  end

  it 'has an Fixnum as a value representation' do
    expect(true_node._value).to be_a Fixnum
    expect(false_node._value).to be_a Fixnum
  end

  describe '#value' do
    it 'returns the boolean representation of the integer' do
      expect(true_node.value).to eq true
      expect(false_node.value).to eq false
    end
  end
end
