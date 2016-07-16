require 'spec_helper'

describe Marvin::AST::If do
  let(:node) do
    Marvin::AST::If.new(
      Marvin::AST::EqualTo.new(
        Marvin::AST::Integer.new(4),
        Marvin::AST::Integer.new(4)
      ),
      Marvin::AST::Block.new(
        Marvin::AST::Integer.new(4)
      )
    )
  end

  it 'inherits from Marvin::AST::Statement' do
    expect(node).to be_a Marvin::AST::Statement
  end

  it 'has a Test as a test' do
    expect(node.test).to be_a Marvin::AST::Test
  end

  it 'has a Block as a body' do
    expect(node.body).to be_a Marvin::AST::Block
  end
end
