require 'spec_helper'

describe Marvin::AST::Call do
  let(:node) do
    Marvin::AST::Call.new(:a, [])
  end

  it 'inherits from Marvin::AST::Expression' do
    expect(node).to be_a Marvin::AST::Expression
  end

  it 'has a Symbol as a name' do
    expect(node.name).to be_a Symbol
  end

  it 'has an Array as arguments' do
    expect(node.arguments).to be_a Array
  end
end
