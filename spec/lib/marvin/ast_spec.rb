require 'spec_helper'

describe Marvin::AST do
  let(:ast) { Marvin::AST.new(Marvin::Node.new('root')) }

  describe '#initialize' do
    it 'creates a nil root' do
      empty_ast = Marvin::AST.new

      expect(empty_ast.root).to be_nil
    end
  end

  describe '#print_tree' do
    it 'prints out a tree' do
      expect { ast.print_tree }.to output("* root\n").to_stdout
    end
  end
end
