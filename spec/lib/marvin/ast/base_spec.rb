require 'spec_helper'

describe Marvin::AST::Base do
  let(:node) { Marvin::AST::Base.new }

  it 'inherits from RLTK::ASTNode' do
    expect(node).to be_a RLTK::ASTNode
  end
end
