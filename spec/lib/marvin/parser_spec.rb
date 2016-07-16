require 'spec_helper'

describe Marvin::Parser do
  it 'inherits from RLTK::Parser' do
    expect(subject).to be_a RLTK::Parser
  end

  describe '.parse' do
    describe 'arithmetic' do
      context 'addition' do
        let(:ast) { get_ast('4 + 4') }
        let(:addition) { ast.first }

        it 'creates an Addition node' do
          expect(addition).to be_a Marvin::AST::Addition
        end

        it 'has an Integer node on the left side' do
          expect(addition.left).to be_a Marvin::AST::Integer
        end

        it 'sets the value on the left side' do
          expect(addition.left.value).to eql 4
        end

        it 'has an Integer node on the right side' do
          expect(addition.right).to be_a Marvin::AST::Integer
        end

        it 'sets the value on the right side' do
          expect(addition.right.value).to eql 4
        end
      end

      context 'subtraction' do
        let(:ast) { get_ast('4 - 4') }
        let(:subtraction) { ast.first }

        it 'creates an Subtraction node' do
          expect(subtraction).to be_a Marvin::AST::Subtraction
        end

        it 'has an Integer node on the left side' do
          expect(subtraction.left).to be_a Marvin::AST::Integer
        end

        it 'sets the value on the left side' do
          expect(subtraction.left.value).to eql 4
        end

        it 'has an Integer node on the right side' do
          expect(subtraction.right).to be_a Marvin::AST::Integer
        end

        it 'sets the value on the right side' do
          expect(subtraction.right.value).to eql 4
        end
      end

      context 'multiplication' do
        let(:ast) { get_ast('4 * 4') }
        let(:multiplication) { ast.first }

        it 'creates an Multiplication node' do
          expect(multiplication).to be_a Marvin::AST::Multiplication
        end

        it 'has an Integer node on the left side' do
          expect(multiplication.left).to be_a Marvin::AST::Integer
        end

        it 'sets the value on the left side' do
          expect(multiplication.left.value).to eql 4
        end

        it 'has an Integer node on the right side' do
          expect(multiplication.right).to be_a Marvin::AST::Integer
        end

        it 'sets the value on the right side' do
          expect(multiplication.right.value).to eql 4
        end
      end

      context 'division' do
        let(:ast) { get_ast('4 / 4') }
        let(:division) { ast.first }

        it 'creates an Division node' do
          expect(division).to be_a Marvin::AST::Division
        end

        it 'has an Integer node on the left side' do
          expect(division.left).to be_a Marvin::AST::Integer
        end

        it 'sets the value on the left side' do
          expect(division.left.value).to eql 4
        end

        it 'has an Integer node on the right side' do
          expect(division.right).to be_a Marvin::AST::Integer
        end

        it 'sets the value on the right side' do
          expect(division.right.value).to eql 4
        end
      end

      context 'chaining multiple operations' do
        let(:ast) { get_ast('4 - 4 * 4 + 4 / 4') }
        let(:rightmost) { ast.first }

        it 'creates an Division node' do
          expect(rightmost).to be_a Marvin::AST::Division
        end

        it 'has an Addition node on the left side' do
          expect(rightmost.left).to be_a Marvin::AST::Addition
        end

        it 'has an Integer node on the right side' do
          expect(rightmost.right).to be_a Marvin::AST::Integer
        end

        it 'sets the value on the right side' do
          expect(rightmost.right.value).to eql 4
        end
      end
    end

    describe 'assignment' do
      let(:ast) { get_ast('a = 4') }
      let(:assignment) { ast.first }

      it 'creates an Assignment node' do
        expect(assignment).to be_a Marvin::AST::Assignment
      end

      it 'has a Symbol as a name' do
        expect(assignment.name).to be_a Symbol
      end

      it 'sets the value of the name' do
        expect(assignment.name).to eql :a
      end

      it 'has an Expression as the value' do
        expect(assignment.value).to be_a_kind_of Marvin::AST::Expression
      end
    end

    describe 'block' do
      let(:ast) { get_ast('if (true) { }') }
      let(:block) { ast.last.body }

      it 'creates a Block node' do
        expect(block).to be_a Marvin::AST::Block
      end

      it 'has an empty body' do
        expect(block.body).to eql []
      end
    end

    describe 'boolean' do
      let(:ast) { get_ast("a = true\nb = false") }
      let(:boolean_true) { ast.first }
      let(:boolean_false) { ast.last }

      it 'creates a Boolean node' do
        expect(ast.first.value).to be_a Marvin::AST::Boolean
      end

      it 'casts to a number for storage' do
        expect(boolean_true.value._value).to be_a Fixnum
        expect(boolean_true.value._value).to eql 1
        expect(boolean_false.value._value).to eql 0
      end

      describe '#to_bool' do
        it 'returns 1 as true' do
          expect(boolean_true.value.value).to eql true
        end

        it 'returns 0 as false' do
          expect(boolean_false.value.value).to eql false
        end
      end
    end

    describe 'call' do
      let(:ast) { get_ast("foo\nbar(1)") }
      let(:call_variable) { ast.first }
      let(:call_function) { ast.last }

      it 'creates a Call node' do
        expect(call_variable).to be_a Marvin::AST::Call
        expect(call_function).to be_a Marvin::AST::Call
      end

      it 'has a Symbol as a name' do
        expect(call_variable.name).to be_a Symbol
      end

      it 'sets the name' do
        expect(call_variable.name).to eql :foo
        expect(call_function.name).to eql :bar
      end

      it 'has an Array for the arguments' do
        expect(call_variable.arguments).to be_a Array
      end

      context 'variable calls' do
        it 'has no arguments' do
          expect(call_variable.arguments).to be_empty
        end
      end

      context 'function calls' do
        it 'sets arguments' do
          expect(call_function.arguments.first).to be_a Marvin::AST::Integer
          expect(call_function.arguments.first.value).to eql 1
        end
      end
    end

    describe 'float' do
      let(:ast) { get_ast('4.0') }
      let(:float) { ast.first }

      it 'creates a Float node' do
        expect(float).to be_a Marvin::AST::Float
      end

      it 'has a Float as a value' do
        expect(float.value).to be_a Float
      end

      it 'sets the value' do
        expect(float.value).to eql 4.0
      end
    end

    describe 'function' do
      let(:ast) { get_ast('fun foo(biz, baz) { 4 }') }
      let(:function) { ast.first }

      it 'creates a Function node' do
        expect(function).to be_a Marvin::AST::Function
      end

      it 'has a Symbol as a name' do
        expect(function.name).to be_a Symbol
      end

      it 'sets the name' do
        expect(function.name).to eql :foo
      end

      it 'has an Array for parameters' do
        expect(function.parameters).to be_a Array
      end

      it 'sets the parameters' do
        expect(function.parameters).to eql [:biz, :baz]
      end

      it 'has a Block for the body' do
        expect(function.body).to be_a Marvin::AST::Block
      end

      it 'sets the body' do
        expect(function.body.body.first).to be_a Marvin::AST::Integer
        expect(function.body.body.first.value).to eql 4
      end
    end

    describe 'if' do
      context 'with test' do
        let(:ast) { get_ast('if (4 == 4) { 4 }') }
        let(:iff) { ast.first }

        it 'creates an If node' do
          expect(iff).to be_a Marvin::AST::If
        end

        it 'has a Test as a test' do
          expect(iff.test).to be_a Marvin::AST::Test
        end

        it 'sets the test' do
          expect(iff.test.left.value).to eql 4
          expect(iff.test.right.value).to eql 4
        end

        it 'has a Block as a body' do
          expect(iff.body).to be_a Marvin::AST::Block
        end

        it 'sets the body' do
          expect(iff.body.body.first).to be_a Marvin::AST::Integer
          expect(iff.body.body.first.value).to eql 4
        end
      end

      context 'with boolean' do
        let(:ast) { get_ast('if (true) { 4 }') }
        let(:iff) { ast.first }

        it 'creates an If node' do
          expect(iff).to be_a Marvin::AST::If
        end

        it 'has a Test as a test' do
          expect(iff.test).to be_a Marvin::AST::Test
        end

        it 'sets the test' do
          expect(iff.test.left.value).to eql true
          expect(iff.test.right.value).to eql true
        end

        it 'has a Block as a body' do
          expect(iff.body).to be_a Marvin::AST::Block
        end

        it 'sets the body' do
          expect(iff.body.body.first).to be_a Marvin::AST::Integer
          expect(iff.body.body.first.value).to eql 4
        end
      end
    end

    describe 'integer' do
      let(:ast) { get_ast('4') }
      let(:integer) { ast.first }

      it 'creates an Integer node' do
        expect(integer).to be_a Marvin::AST::Integer
      end

      it 'has a Fixnum as the value' do
        expect(integer.value).to be_a Fixnum
      end

      it 'sets the value' do
        expect(integer.value).to eql 4
      end
    end

    describe 'print' do
      let(:ast) { get_ast('print(4)') }
      let(:print) { ast.first }

      it 'creates a Print node' do
        expect(print).to be_a Marvin::AST::Print
      end

      it 'has an Expression as a body' do
        expect(print.body).to be_a_kind_of Marvin::AST::Expression
      end

      it 'sets the body' do
        expect(print.body.value).to eql 4
      end
    end

    describe 'program' do
      let(:program) { Marvin::Parser.parse(Marvin::Lexer.lex('4')) }

      it 'creates a Program node' do
        expect(program).to be_a Marvin::AST::Program
      end

      it 'has an Array for contents' do
        expect(program.contents).to be_a Array
      end

      it 'sets the contents' do
        expect(program.contents.first.value).to eql 4
      end
    end

    describe 'string' do
      let(:ast) { get_ast('"foobar"') }
      let(:string) { ast.first }

      it 'creates a String node' do
        expect(string).to be_a Marvin::AST::String
      end

      it 'has a String as the value' do
        expect(string.value).to be_a String
      end

      it 'sets the value' do
        expect(string.value).to eql '"foobar"'
      end
    end

    describe 'test' do
      context 'equal to' do
        let(:ast) { get_ast('4 == 4') }
        let(:equal_to) { ast.first }

        it 'creates an EqualTo node' do
          expect(equal_to).to be_a Marvin::AST::EqualTo
        end

        it 'has an Integer node on the left side' do
          expect(equal_to.left).to be_a Marvin::AST::Integer
        end

        it 'sets the value on the left side' do
          expect(equal_to.left.value).to eql 4
        end

        it 'has an Integer node on the right side' do
          expect(equal_to.right).to be_a Marvin::AST::Integer
        end

        it 'sets the value on the right side' do
          expect(equal_to.right.value).to eql 4
        end
      end

      context 'not equal to' do
        let(:ast) { get_ast('4 != 4') }
        let(:not_equal_to) { ast.first }

        it 'creates an NotEqualTo node' do
          expect(not_equal_to).to be_a Marvin::AST::NotEqualTo
        end

        it 'has an Integer node on the left side' do
          expect(not_equal_to.left).to be_a Marvin::AST::Integer
        end

        it 'sets the value on the left side' do
          expect(not_equal_to.left.value).to eql 4
        end

        it 'has an Integer node on the right side' do
          expect(not_equal_to.right).to be_a Marvin::AST::Integer
        end

        it 'sets the value on the right side' do
          expect(not_equal_to.right.value).to eql 4
        end
      end

      context 'less than' do
        let(:ast) { get_ast('4 < 4') }
        let(:less_than) { ast.first }

        it 'creates an LessThan node' do
          expect(less_than).to be_a Marvin::AST::LessThan
        end

        it 'has an Integer node on the left side' do
          expect(less_than.left).to be_a Marvin::AST::Integer
        end

        it 'sets the value on the left side' do
          expect(less_than.left.value).to eql 4
        end

        it 'has an Integer node on the right side' do
          expect(less_than.right).to be_a Marvin::AST::Integer
        end

        it 'sets the value on the right side' do
          expect(less_than.right.value).to eql 4
        end
      end

      context 'greater than' do
        let(:ast) { get_ast('4 > 4') }
        let(:greater_than) { ast.first }

        it 'creates an LessThan node' do
          expect(greater_than).to be_a Marvin::AST::GreaterThan
        end

        it 'has an Integer node on the left side' do
          expect(greater_than.left).to be_a Marvin::AST::Integer
        end

        it 'sets the value on the left side' do
          expect(greater_than.left.value).to eql 4
        end

        it 'has an Integer node on the right side' do
          expect(greater_than.right).to be_a Marvin::AST::Integer
        end

        it 'sets the value on the right side' do
          expect(greater_than.right.value).to eql 4
        end
      end
    end
  end
end

def get_ast(source)
  Marvin::Parser.parse(Marvin::Lexer.lex(source)).contents
end
