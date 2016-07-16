require 'spec_helper'

describe Marvin::AST::Block do
  let(:node) do
    Marvin::AST::Block.new([
      Marvin::AST::Integer.new(4),
      Marvin::AST::Integer.new(1)
    ])
  end

  it 'inherits from Marvin::AST::Statement' do
    expect(node).to be_a Marvin::AST::Statement
  end

  it 'has an Array as a body' do
    expect(node.body).to be_a Array
  end
end
