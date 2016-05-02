require 'digest/md5'

module Marvin

  # The Parser will verify the syntax of the found Tokens.
  class Parser
    attr_accessor :tokens, :cst, :ast, :config

    # Creates a new Parser with a given Lexer and configuration.
    #
    # @param [Array<Marvin::Token>] tokens A bunch of tokens.
    # @param [Marvin::Configuration] config Configuration instance.
    # @return [Marvin::Parser] An un-run parser.
    def initialize(tokens, config: Marvin::Configuration.new)
      @tokens = tokens
      @cst    = Marvin::CST.new
      @ast    = Marvin::AST.new
      @config = config
    end

    # Will parse the tokens given.
    #
    # @return [Boolean] Whether the source is valid or not.
    def parse!
      @counter = 0

      @config.logger.info('Parsing...')

      if @tokens.empty?
        empty = Marvin::Token.new(
          lexeme: '',
          kind: :empty
        )

        return Marvin::Error::ParseError.new(empty, :block_start)
      end

      # Get on your flip-flops! Going to parse until we're at the end of the
      # tokens.
      if @counter == 0 .. @tokens.length
        parse_program!
      end

      if @config.logger.verbose
        @config.logger.info("\n")
        @config.logger.info(@cst.print_tree)

        @config.logger.info("\n")
        @config.logger.info(@ast.print_tree)
      end

      @symbol_table = Marvin::SymbolTable.new(@config)
      @symbol_table.from_ast(@ast)

      if @config.logger.verbose
        @config.logger.info("\n")
        @config.logger.info(@symbol_table.print_tree)
      end

      @config.logger.info("Parse completed successfully.\n")
      @config.logger.info("Scope checking completed successfully.\n")
      @config.logger.info("Type checking completed successfully.\n")

      true
    end

    private

    # Checks whether or not the current token matches the expected kind.
    #
    # @param [Symbol] kind The expected kind.
    # @return [Boolean] Whether or not the kind matches.
    def match?(kind)
      current_token.kind == kind
    end

    # Match against one of the given kinds.
    #
    # @param [Array<Symbol>] kinds The expected kinds to match against.
    #
    # @return [Boolean] Whether one of the kinds match.
    def match_any?(kinds)
      kinds.map { |kind| match?(kind) }.any?
    end

    # Advance the current token if the kinds match, and fails out if they don't.
    #
    # @param [Symbol] kind The expected kind.
    # @param [Marvin::Node] cst_node The current parent node for the CST.
    # @param [Marvin::Node] ast_node The current parent node for the AST.
    # @return [Boolean] Whether or not the kind matches.
    def advance!(kind, cst_node: nil, ast_node: nil)
      return Marvin::Error::ParseError.new(current_token, kind) unless match?(kind)

      cst_node << Marvin::Node.new(current_token) if cst_node
      ast_node << Marvin::Node.new(current_token) if ast_node

      @counter += 1

      true
    end

    # Returns the token at the counter.
    #
    # @return [Marvin::Token] The token at the counter.
    def current_token
      @tokens[@counter]
    end

    # Parses a program.
    #
    #   Program ::= Block $
    #
    # @return [Boolean] Whether this parsing succeeds.
    def parse_program!
      @config.logger.info('  Parsing program...')

      cst_program_node = Marvin::Node.new(Marvin::Production.new(name: 'Program'))
      ast_program_node = Marvin::Node.new(Marvin::Production.new(name: 'Program'))

      @cst.root = cst_program_node
      @ast.root = ast_program_node

      parse_block!(cst_program_node, ast_program_node)
      advance!(:program_end, cst_node: cst_program_node, ast_node: ast_program_node)
    end

    # Parses a block.
    #
    #   Block ::= { StatementList }
    #
    # @param [Marvin::Node] cst_node The current parent node for the CST.
    # @param [Marvin::Node] ast_node The current parent node for the AST.
    # @return [Boolean] Whether this parsing succeeds.
    def parse_block!(cst_node, ast_node)
      @config.logger.info('  Parsing block...')

      cst_block_node = Marvin::Node.new(Marvin::Production.new(name: 'Block'))
      ast_block_node = Marvin::Node.new(Marvin::Production.new(name: 'Block'))

      cst_node << cst_block_node
      ast_node << ast_block_node

      advance!(:block_begin, cst_node: cst_block_node)
      parse_statement_list!(cst_block_node, ast_block_node)
      advance!(:block_end, cst_node: cst_block_node)
    end

    # Parses a statement list.
    #
    #   StatementList ::= Statement StatementList
    #                 ::= ε
    #
    # @param [Marvin::Node] cst_node The current parent node for the CST.
    # @param [Marvin::Node] ast_node The current parent node for the AST.
    # @return [Boolean] Whether this parsing succeeds.
    def parse_statement_list!(cst_node, ast_node)
      @config.logger.info('  Parsing statement list...')

      kinds = [:print, :char, :type, :while, :if_statement, :block_begin]

      if match_any?(kinds)
        cst_statement_list_node = Marvin::Node.new(Marvin::Production.new(name: 'StatementList'))

        cst_node << cst_statement_list_node

        parse_statement!(cst_statement_list_node, ast_node)
        parse_statement_list!(cst_statement_list_node, ast_node)
      elsif match?(:block_end)
        true
      else
        return Marvin::Error::ParseError.new(current_token, kinds)
      end
    end

    # Parses a statement.
    #
    #   Statement ::== PrintStatement
    #             ::== AssignmentStatement
    #             ::== VarDecl
    #             ::== WhileStatement
    #             ::== IfStatement
    #             ::== Block
    #
    # @param [Marvin::Node] cst_node The current parent node for the CST.
    # @param [Marvin::Node] ast_node The current parent node for the AST.
    # @return [Boolean] Whether this parsing succeeds.
    def parse_statement!(cst_node, ast_node)
      @config.logger.info('  Parsing statement...')

      if match?(:print)
        return parse_print_statement!(cst_node, ast_node)
      end

      if match?(:char)
        return parse_assignment_statement!(cst_node, ast_node)
      end

      if match?(:type)
        return parse_var_decl!(cst_node, ast_node)
      end

      if match?(:while)
        return parse_while_statement!(cst_node, ast_node)
      end

      if match?(:if_statement)
        return parse_if_statement!(cst_node, ast_node)
      end

      if match?(:block_begin)
        return parse_block!(cst_node, ast_node)
      end

      return Marvin::Error::ParseError.new(token, [:print, :char, :type, :while, :if_statement, :block_begin])
    end

    # Parses a print statement.
    #
    #   PrintStatement ::== print ( Expr )
    #
    # @param [Marvin::Node] cst_node The current parent node for the CST.
    # @param [Marvin::Node] ast_node The current parent node for the AST.
    # @return [Boolean] Whether this parsing succeeds.
    def parse_print_statement!(cst_node, ast_node)
      @config.logger.info('  Parsing print statement...')

      cst_print_node = Marvin::Node.new(Marvin::Production.new(name: 'Print'))
      ast_print_node = Marvin::Node.new(Marvin::Production.new(name: 'Print'))

      cst_node << cst_print_node
      ast_node << ast_print_node

      advance!(:print, cst_node: cst_print_node)
      advance!(:open_parenthesis, cst_node: cst_print_node)
      parse_expr!(cst_print_node, ast_print_node)
      advance!(:close_parenthesis, cst_node: cst_print_node)
    end

    # Parses an assignment statement.
    #
    #   AssignmentStatement ::== Id = Expr
    #
    # @param [Marvin::Node] cst_node The current parent node for the CST.
    # @param [Marvin::Node] ast_node The current parent node for the AST.
    # @return [Boolean] Whether this parsing succeeds.
    def parse_assignment_statement!(cst_node, ast_node)
      @config.logger.info('  Parsing assignment statement...')

      cst_assignment_node = Marvin::Node.new(Marvin::Production.new(name: 'Assignment'))
      ast_assignment_node = Marvin::Node.new(Marvin::Production.new(name: 'Assignment'))

      cst_node << cst_assignment_node
      ast_node << ast_assignment_node

      parse_id!(cst_assignment_node, ast_assignment_node)
      advance!(:assignment, cst_node: cst_assignment_node)
      parse_expr!(cst_assignment_node, ast_assignment_node)
    end

    # Parses a variable declaration.
    #
    #   VarDecl ::== type Id
    #
    # @param [Marvin::Node] cst_node The current parent node for the CST.
    # @param [Marvin::Node] ast_node The current parent node for the AST.
    # @return [Boolean] Whether this parsing succeeds.
    def parse_var_decl!(cst_node, ast_node)
      @config.logger.info('  Parsing variable declaration...')

      cst_var_decl_node = Marvin::Node.new(Marvin::Production.new(name: 'VariableDeclaration'))
      ast_var_decl_node = Marvin::Node.new(Marvin::Production.new(name: 'VariableDeclaration'))

      cst_node << cst_var_decl_node
      ast_node << ast_var_decl_node

      advance!(:type, cst_node: cst_var_decl_node, ast_node: ast_var_decl_node)
      parse_id!(cst_var_decl_node, ast_var_decl_node)
    end

    # Parses a while statement.
    #
    #   WhileStatement ::== while BooleanExpr Block
    #
    # @param [Marvin::Node] cst_node The current parent node for the CST.
    # @param [Marvin::Node] ast_node The current parent node for the AST.
    # @return [Boolean] Whether this parsing succeeds.
    def parse_while_statement!(cst_node, ast_node)
      @config.logger.info('  Parsing while statement...')

      cst_while_node = Marvin::Node.new(Marvin::Production.new(name: 'WhileStatement'))
      ast_while_node = Marvin::Node.new(Marvin::Production.new(name: 'WhileStatement'))

      cst_node << cst_while_node
      ast_node << ast_while_node

      advance!(:while, cst_node: cst_while_node)
      parse_boolean_expr!(cst_while_node, ast_while_node)
      parse_block!(cst_while_node, ast_while_node)
    end

    # Parses an if statement.
    #
    #   IfStatement ::== if BooleanExpr Block
    #
    # @param [Marvin::Node] cst_node The current parent node for the CST.
    # @param [Marvin::Node] ast_node The current parent node for the AST.
    # @return [Boolean] Whether this parsing succeeds.
    def parse_if_statement!(cst_node, ast_node)
      @config.logger.info('  Parsing if statement...')

      cst_if_node = Marvin::Node.new(Marvin::Production.new(name: 'IfStatement'))
      ast_if_node = Marvin::Node.new(Marvin::Production.new(name: 'IfStatement'))

      cst_node << cst_if_node
      ast_node << ast_if_node

      advance!(:if_statement, cst_node: cst_if_node)
      parse_boolean_expr!(cst_if_node, ast_if_node)
      parse_block!(cst_if_node, ast_if_node)
    end

    # Parses an expression.
    #
    #   Expr ::== IntExpr
    #        ::== StringExpr
    #        ::== BooleanExpr
    #        ::== Id
    #
    # @param [Marvin::Node] cst_node The current parent node for the CST.
    # @param [Marvin::Node] ast_node The current parent node for the AST.
    # @return [Boolean] Whether this parsing succeeds.
    def parse_expr!(cst_node, ast_node)
      @config.logger.info('  Parsing expression...')

      if match?(:digit)
        parse_int_expr!(cst_node, ast_node)
      elsif match?(:string)
        parse_string_expr!(cst_node, ast_node)
      elsif match?(:boolval) || match?(:open_parenthesis)
        parse_boolean_expr!(cst_node, ast_node)
      elsif match?(:char)
        parse_id!(cst_node, ast_node)
      end

      # HACK: The following two conditionals shouldn't be here. We should be
      # just calling #parse_int_expr! or #parse_boolean_expr! instead. But, this
      # may make it LL(2) (vs. LL(1)), so ¯\_(ツ)_/¯.

      if match?(:intop)
        advance!(:intop, cst_node: cst_node, ast_node: ast_node)
        parse_expr!(cst_node, ast_node)
      end

      if match?(:boolop)
        advance!(:boolop, cst_node: cst_node, ast_node: ast_node)
        parse_expr!(cst_node, ast_node)
      end
    end

    # Parses an integer expression.
    #
    #   IntExpr ::== digit intop Expr
    #           ::== digit
    #
    # @param [Marvin::Node] cst_node The current parent node for the CST.
    # @param [Marvin::Node] ast_node The current parent node for the AST.
    # @return [Boolean] Whether this parsing succeeds.
    def parse_int_expr!(cst_node, ast_node)
      @config.logger.info('  Parsing integer expression...')

      advance!(:digit, cst_node: cst_node, ast_node: ast_node)

      if match?(:intop)
        advance!(:intop)
        parse_expr!(cst_node, ast_node)
      end
    end

    # Parses a string expression.
    #
    #   StringExpr ::= " CharList "
    #
    # @param [Marvin::Node] cst_node The current parent node for the CST.
    # @param [Marvin::Node] ast_node The current parent node for the AST.
    # @return [Boolean] Whether this parsing succeeds.
    def parse_string_expr!(cst_node, ast_node)
      @config.logger.info('  Parsing string expression...')

      advance!(:string, cst_node: cst_node, ast_node: ast_node)
    end

    # Parses a boolean expression.
    #
    #   BooleanExpr ::= ( Expr boolop Expr )
    #               ::= boolval
    #
    # @param [Marvin::Node] cst_node The current parent node for the CST.
    # @param [Marvin::Node] ast_node The current parent node for the AST.
    # @return [Boolean] Whether this parsing succeeds.
    def parse_boolean_expr!(cst_node, ast_node)
      @config.logger.info('  Parsing boolean expression...')

      cst_boolean_expr_node = Marvin::Node.new(Marvin::Production.new(name: 'BooleanExpr'))
      ast_boolean_expr_node = Marvin::Node.new(Marvin::Production.new(name: 'BooleanExpr'))

      cst_node << cst_boolean_expr_node
      ast_node << ast_boolean_expr_node

      if match?(:open_parenthesis)
        advance!(:open_parenthesis, cst_node: cst_boolean_expr_node)
        parse_expr!(cst_boolean_expr_node, ast_boolean_expr_node)
        advance!(:boolop, cst_node: cst_boolean_expr_node, ast_node: ast_boolean_expr_node)
        parse_expr!(cst_boolean_expr_node, ast_boolean_expr_node)
        advance!(:close_parenthesis, cst_node: cst_boolean_expr_node)
      else
        advance!(:boolval, cst_node: cst_boolean_expr_node, ast_node: ast_boolean_expr_node)
      end
    end

    # Parses an identifier.
    #
    #   Id ::== char
    #
    # @param [Marvin::Node] cst_node The current parent node for the CST.
    # @param [Marvin::Node] ast_node The current parent node for the AST.
    # @return [Boolean] Whether this parsing succeeds.
    def parse_id!(cst_node, ast_node)
      @config.logger.info('  Parsing identifier...')

      advance!(:char, cst_node: cst_node, ast_node: ast_node)
    end
  end
end
