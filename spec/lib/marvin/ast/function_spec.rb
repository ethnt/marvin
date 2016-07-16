require 'spec_helper'

describe Marvin::AST::Function do
  let(:node) do
    Marvin::AST::Function.new(
      :foo,
      [:biz, :baz],
      Marvin::AST::Block.new(
        Marvin::AST::Integer.new(4)
      )
    )
  end

  it 'inherits from Marvin::AST::Statement' do
    expect(node).to be_a Marvin::AST::Statement
  end

  it 'has a Symbol as a name' do
    expect(node.name).to be_a Symbol
  end

  it 'has an Array as a list of parameters' do
    expect(node.parameters).to be_a Array
  end

  it 'has a Block as a body' do
    expect(node.body).to be_a Marvin::AST::Block
  end
end
