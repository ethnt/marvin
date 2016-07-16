require 'spec_helper'

describe Marvin::AST::Assignment do
  let(:node) do
    Marvin::AST::Assignment.new(
      :a,
      Marvin::AST::Integer.new(4)
    )
  end

  it 'inherits from Marvin::AST::Statement' do
    expect(node).to be_a Marvin::AST::Statement
  end

  it 'has an Symbol node as a name' do
    expect(node.name).to be_a Symbol
  end

  it 'has an Expression node for the value' do
    expect(node.value).to be_a Marvin::AST::Expression
  end
end
