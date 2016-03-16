require 'spec_helper'

describe Marvin::CST do
  let(:cst) { Marvin::CST.new(Marvin::Node.new('root')) }

  describe '#initialize' do
    it 'creates a nil root' do
      empty_cst = Marvin::CST.new

      expect(empty_cst.root).to be_nil
    end
  end

  describe '#print_tree' do
    it 'prints out a tree' do
      expect { cst.print_tree }.to output("* root\n").to_stdout
    end
  end
end
