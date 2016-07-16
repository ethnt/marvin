require 'spec_helper'

describe Marvin::AST::Print do
  let(:node) do
    Marvin::AST::Print.new(Marvin::AST::Integer.new(4))
  end

  it 'inherits from Marvin::AST::Statement' do
    expect(node).to be_a Marvin::AST::Statement
  end

  it 'has a Expression as a body' do
    expect(node.body).to be_a Marvin::AST::Expression
  end
end
