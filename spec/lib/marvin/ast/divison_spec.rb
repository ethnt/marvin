require 'spec_helper'

describe Marvin::AST::Division do
  let(:node) do
    Marvin::AST::Division.new(
      Marvin::AST::Integer.new(4),
      Marvin::AST::Integer.new(4)
    )
  end

  it 'inherits from Marvin::AST::Expression' do
    expect(node).to be_a Marvin::AST::Expression
  end

  it 'has an Expression node on the left side' do
    expect(node.left).to be_a Marvin::AST::Expression
  end

  it 'has an Expression node on the right side' do
    expect(node.right).to be_a Marvin::AST::Expression
  end
end
