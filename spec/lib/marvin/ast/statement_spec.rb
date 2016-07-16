require 'spec_helper'

describe Marvin::AST::Statement do
  let(:node) { Marvin::AST::Statement.new }

  it 'inherits from Marvin::AST::Base' do
    expect(node).to be_a Marvin::AST::Base
  end
end
