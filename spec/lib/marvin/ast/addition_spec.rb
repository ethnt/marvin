require 'spec_helper'

describe Marvin::AST::Addition do
  let(:node) do
    Marvin::AST::Addition.new(
      Marvin::AST::Integer.new(4),
      Marvin::AST::Integer.new(4)
    )
  end

  it 'inherits from Marvin::AST::Arithmetic' do
    expect(node).to be_a Marvin::AST::Arithmetic
  end
end
