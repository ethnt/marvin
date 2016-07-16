require 'spec_helper'

describe Marvin::AST::Program do
  let(:node) do
    Marvin::AST::Program.new([])
  end

  it 'inherits from Marvin::AST::Base' do
    expect(node).to be_a Marvin::AST::Base
  end

  it 'has an Array as contents' do
    expect(node.contents).to be_a Array
  end
end
