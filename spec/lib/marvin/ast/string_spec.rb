require 'spec_helper'

describe Marvin::AST::String do
  let(:node) do
    Marvin::AST::String.new('foo')
  end

  it 'inherits from Marvin::AST::Expression' do
    expect(node).to be_a Marvin::AST::Expression
  end

  it 'has an String as a value representation' do
    expect(node.value).to be_a String
  end
end
