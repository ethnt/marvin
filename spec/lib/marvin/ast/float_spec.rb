require 'spec_helper'

describe Marvin::AST::Float do
  let(:node) do
    Marvin::AST::Float.new(4.0)
  end

  it 'inherits from Marvin::AST::Expression' do
    expect(node).to be_a Marvin::AST::Expression
  end

  it 'has an Float as a value representation' do
    expect(node.value).to be_a Float
  end
end
