require 'spec_helper'

describe Marvin::AST::EqualTo do
  let(:node) do
    Marvin::AST::EqualTo.new(
      Marvin::AST::Integer.new(4),
      Marvin::AST::Integer.new(4)
    )
  end

  it 'inherits from Marvin::AST::Test' do
    expect(node).to be_a Marvin::AST::Test
  end
end
