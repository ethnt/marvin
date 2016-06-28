require 'rltk/ast'

module Marvin
  class Expression < RLTK::ASTNode
  end

  class IntegerExpression < Expression
    value :value, Integer
  end

  class BooleanExpression < Expression
    value :value, String
  end

  class StringExpression < Expression
    value :value, String
  end

  class TypeExpression < Expression
    value :type, Symbol
  end

  class IdentifierExpression < Expression
    value :name, Symbol
  end

  class EqualityExpression < Expression
    child :left, Expression
    child :right, Expression
  end

  class EqualToExpression < EqualityExpression; end
  class NotEqualToExpression < EqualityExpression; end

  class BinaryExpression < Expression
    child :left, Expression
    child :right, Expression
  end

  class AdditionExpression < BinaryExpression; end
  class SubtractionExpression < BinaryExpression; end
  class MultiplicationExpression < BinaryExpression; end
  class DivisionExpression < BinaryExpression; end

  class Statement < RLTK::ASTNode
  end

  class BlockStatement < Statement
    child :statements, [Statement]
  end

  class Program < RLTK::ASTNode
    child :block, BlockStatement
  end

  class IfStatement < Statement
    child :test, BooleanExpression
    child :block, BlockStatement
  end

  class WhileStatement < Statement
    child :test, BooleanExpression
    child :block, BlockStatement
  end

  class AssignmentStatement < Statement
    value :name, IdentifierExpression
    value :value, Expression
  end

  class VariableDeclarationStatement < Statement
    value :type, TypeExpression
    value :name, IdentifierExpression
  end

  class PrintStatement < Statement
    value :expression, Expression
  end

end
