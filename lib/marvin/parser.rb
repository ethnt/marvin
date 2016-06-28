module Marvin
  class Parser < RLTK::Parser
    list(:programs, 'program')

    production(:program) do
      clause('.block T_EOP') { |b| Program.new(b) }
    end

    production(:block) do
      clause('T_LBRACKET statements T_RBRACKET') { |_, statements, _| BlockStatement.new(statements) }
    end

    list(:statements, 'statement')

    production(:statement) do
      clause('print_statement') { |ps| ps }
      clause('assignment_statement') { |as| as }
      clause('variable_declaration_statement') { |vds| vds }
      clause('while_statement') { |ws| ws }
      clause('if_statement') { |is| is }
      clause('block') { |b| b }
    end

    production(:print_statement) do
      clause('T_PRINT T_LPAREN expression T_RPAREN') { |_, _, expr, _| PrintStatement.new(expr) }
    end

    production(:assignment_statement) do
      clause('T_IDENT T_ASSIGN expression') { |name, _, value| AssignmentStatement.new(IdentifierExpression.new(name), value) }
    end

    production(:variable_declaration_statement) do
      clause('T_TYPE T_IDENT') do |t, i|
        VariableDeclarationStatement.new(TypeExpression.new(t), IdentifierExpression.new(i))
      end
    end

    production(:while_statement) do
      clause('T_WHILE T_LPAREN boolean_expression T_RPAREN block') do |_, _, t, _, b|
        WhileStatement.new(t, b)
      end
    end

    production(:if_statement) do
      clause('T_WHILE T_LPAREN boolean_expression T_RPAREN block') do |_, _, t, _, b|
        IfStatement.new(t, b)
      end
    end

    production(:expression) do
      clause('integer_expression') { |i| i }

      clause('boolean_expression') { |n| n }

      clause('T_STRING') { |s| StringExpression.new(s) }
      clause('T_IDENT') { |i| IdentifierExpression.new(i.to_sym) }
    end

    production(:integer_expression) do
      clause('T_INTEGER') { |i| IntegerExpression.new(i) }
      clause('expression T_INTOP expression') do |left, op, right|
        case op
        when :+
          AdditionExpression.new(left, right)
        when :-
          SubtractionExpression.new(left, right)
        when :*
          MultiplicationExpression.new(left, right)
        when :/
          DivisonExpression.new(left, right)
        end
      end
    end

    production(:boolean_expression) do
      clause('T_BOOLVAL') { |b| BooleanExpression.new(b.to_s) }
      clause('expression T_INTOP expression') do |left, op, right|
        case op
        when :==
          EqualToExpression.new(left, right)
        when :!=
          NotEqualToExpression.new(left, right)
        end
      end
    end

    finalize
  end
end
