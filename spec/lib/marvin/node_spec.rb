require 'spec_helper'

describe Marvin::Node do
  it 'is a subclass of Tree::TreeNode' do
    expect(Marvin::Node < Tree::TreeNode).to be_truthy
  end
end
