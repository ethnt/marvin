require 'spec_helper'

describe Marvin::AST::Expression do
  let(:node) { Marvin::AST::Expression.new }

  it 'inherits from Marvin::AST::Base' do
    expect(node).to be_a Marvin::AST::Base
  end
end
