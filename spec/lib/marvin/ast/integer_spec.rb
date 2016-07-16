require 'spec_helper'

describe Marvin::AST::Integer do
  let(:node) do
    Marvin::AST::Integer.new(4)
  end

  it 'inherits from Marvin::AST::Expression' do
    expect(node).to be_a Marvin::AST::Expression
  end

  it 'has an Integer as a value representation' do
    expect(node.value).to be_a Integer
  end
end
