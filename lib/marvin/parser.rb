require 'digest/md5'

module Marvin

  # The Parser will verify the syntax of the found Tokens.
  class Parser
    attr_accessor :tokens, :cst, :config

    # Creates a new Parser with a given Lexer and configuration.
    #
    # @param [Array<Marvin::Token>] tokens A bunch of tokens.
    # @param [Marvin::CST] cst A CST.
    # @param [Marvin::Configuration] config Configuration instance.
    # @return [Marvin::Parser] An un-run parser.
    def initialize(tokens, cst = Marvin::CST.new, config = Marvin::Configuration.new)
      @tokens = tokens
      @cst    = cst
      @config = config
    end

    # Will parse the tokens given.
    #
    # @return [Boolean] Whether the source is valid or not.
    def parse!
      @counter = 0

      @config.logger.info('Parsing...')

      if @tokens.empty?
        fail Marvin::Error::ParseError.new(Marvin::Token.new('', :empty), :block_start)
      end

      # Get on your flip-flops! Going to parse until we're at the end of the
      # tokens.
      if @counter == 0 .. @tokens.length
        parse_program!
      end

      @config.logger.info("Parse completed successfully.\n\n")

      true
    end

    private

    # Checks whether or not the current token matches the expected kind.
    #
    # @param [Symbol] kind The expected kind.
    # @param [Marvin::Node] parent_node The current parent node.
    # @param [Boolean] fail_out Whether or not to fail out if we don't find a
    #                           match.
    # @param [Boolean] advance Whether or not to advance the pointer if a match
    #                          is found.
    # @return [Boolean] Whether or not the kind matches.
    def match?(kind, parent_node = nil, fail_out: true, advance: true)

      # We have a match.
      if current_token.kind == kind
        if advance
          if parent_node
            parent_node << Marvin::Node.new(current_token)
          end

          @counter += 1
        end

        true
      else
        fail Marvin::Error::ParseError.new(current_token, kind) if fail_out

        false
      end
    end

    # Match against one of the given kinds.
    #
    # @param [Array<Symbol>] kinds The expected kinds to match against.
    #
    # @return [Boolean] Whether one of the kinds match.
    def match_any?(kinds, fail_out: false, advance: false)
      kinds.each do |kind|
        if match?(kind, fail_out: fail_out, advance: advance)
          return true
        end
      end

      false
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
    def parse_program!
      @config.logger.info('  Parsing program...')

      program_node = Marvin::Node.new('<Program>')

      @cst.root = program_node

      parse_block!(program_node)
      match?(:program_end, program_node)

      # If there are more tokens, that means there is more than one program in
      # this file.
      # if current_token
      #   parse_program!
      # end
    end

    # Parses a block.
    #
    #   Block ::= { StatementList }
    #
    # @param [Marvin::Node] parent_node The parent node.
    def parse_block!(parent_node)
      @config.logger.info('  Parsing block...')

      block_node = Marvin::Node.new('<Block>')

      parent_node << block_node

      match?(:block_begin, block_node)
      parse_statement_list!(block_node)
      match?(:block_end, block_node)
    end

    # Parses a statement list.
    #
    #   StatementList ::= Statement StatementList
    #                 ::= ε
    #
    # @param [Marvin::Node] parent_node The parent node.
    def parse_statement_list!(parent_node)
      @config.logger.info('  Parsing statement list...')

      kinds = [:print, :char, :type, :while, :if_statement, :block_begin]

      if match_any?(kinds)
        statement_list_node = Marvin::Node.new('<StatementList>')

        parent_node << statement_list_node

        parse_statement!(statement_list_node)
        parse_statement_list!(statement_list_node)
      elsif match?(:block_end, fail_out: false, advance: false)
        true
      else
        fail Marvin::Error::ParseError.new(current_token, kinds)
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
    # @param [Marvin::Node] parent_node The parent node.
    def parse_statement!(parent_node)
      @config.logger.info('  Parsing statement...')

      if match?(:print, fail_out: false, advance: false)
        return parse_print_statement!(parent_node)
      end

      if match?(:char, fail_out: false, advance: false)
        return parse_assignment_statement!(parent_node)
      end

      if match?(:type, fail_out: false, advance: false)
        return parse_var_decl!(parent_node)
      end

      if match?(:while, fail_out: false, advance: false)
        return parse_while_statement!(parent_node)
      end

      if match?(:if_statement, fail_out: false, advance: false)
        return parse_if_statement!(parent_node)
      end

      if match?(:block_begin, fail_out: false, advance: false)
        return parse_block!(parent_node)
      end

      fail Marvin::Error::ParseError.new(token, [:print, :char, :type, :while, :if_statement, :block_begin])
    end

    # Parses a print statement.
    #
    #   PrintStatement ::== print ( Expr )
    #
    # @param [Marvin::Node] parent_node The parent node.
    def parse_print_statement!(parent_node)
      @config.logger.info('  Parsing print statement...')

      print_node = Marvin::Node.new('<Print>')

      parent_node << print_node

      match?(:print, print_node, fail_out: false)
      match?(:open_parenthesis, print_node, fail_out: false)
      parse_expr!(print_node)
      match?(:close_parenthesis, print_node, fail_out: false)
    end

    # Parses an assignment statement.
    #
    #   AssignmentStatement ::== Id = Expr
    def parse_assignment_statement!(parent_node)
      @config.logger.info('  Parsing assignment statement...')

      assignment_node = Marvin::Node.new('<Assignment>')
      parent_node << assignment_node

      parse_id!(assignment_node)
      match?(:assignment, assignment_node)
      parse_expr!(assignment_node)
    end

    # Parses a variable declaration.
    #
    #   VarDecl ::== type Id
    def parse_var_decl!(parent_node)
      @config.logger.info('  Parsing variable declaration...')

      var_decl_node = Marvin::Node.new('<VariableDeclaration>')
      parent_node << var_decl_node

      match?(:type, var_decl_node)
      parse_id!(var_decl_node)
    end

    # Parses a while statement.
    #
    #   WhileStatement ::== while BooleanExpr Block
    def parse_while_statement!(parent_node)
      @config.logger.info('  Parsing while statement...')

      while_node = Marvin::Node.new('<WhileStatement>')
      parent_node << while_node

      match?(:while, while_node)
      parse_boolean_expr!(while_node)
      parse_block!(while_node)
    end

    # Parses an if statement.
    #
    #   IfStatement ::== if BooleanExpr Block
    def parse_if_statement!(parent_node)
      @config.logger.info('  Parsing if statement...')

      if_node = Marvin::Node.new('<IfStatement>')
      parent_node << if_node

      match?(:if_statement, if_node)
      parse_boolean_expr!(if_node)
      parse_block!(if_node)
    end

    # Parses an expression.
    #
    #   Expr ::== IntExpr
    #        ::== StringExpr
    #        ::== BooleanExpr
    #        ::== Id
    def parse_expr!(parent_node)
      @config.logger.info('  Parsing expression...')

      if match?(:digit, fail_out: false, advance: false)
        parse_int_expr!(parent_node)
      elsif match?(:string, fail_out: false, advance: false)
        parse_string_expr!(parent_node)
      elsif match?(:boolval, fail_out: false, advance: false) || match?(:open_parenthesis, fail_out: false, advance: false)
        parse_boolean_expr!(parent_node)
      elsif match?(:char, fail_out: false, advance: false)
        parse_id!(parent_node)
      else
        fail
      end
    end

    # Parses an integer expression.
    #
    #   IntExpr ::== digit intop Expr
    #           ::== digit
    def parse_int_expr!(parent_node)
      @config.logger.info('  Parsing integer expression...')

      match?(:digit, parent_node)

      return parse_expr!(parent_node) if match?(:intop, fail_out: false)
    end

    # Parses a string expression.
    #
    #   StringExpr ::= " CharList "
    def parse_string_expr!(parent_node)
      @config.logger.info('  Parsing string expression...')

      match?(:string, parent_node)
    end

    # Parses a boolean expression.
    #
    #   BooleanExpr ::= ( Expr boolop Expr )
    #               ::= boolval
    def parse_boolean_expr!(parent_node)
      @config.logger.info('  Parsing boolean expression...')

      if match?(:open_parenthesis, fail_out: false, advance: false)
        match?(:open_parenthesis, parent_node)
        parse_expr!(parent_node)
        match?(:boolop, parent_node)
        parse_expr!(parent_node)
        match?(:close_parenthesis, parent_node)
      else
        match?(:boolval, parent_node)
      end
    end

    # Parses an identifier.
    #
    #   Id ::== char
    def parse_id!(parent_node)
      @config.logger.info('  Parsing identifier...')

      match?(:char, parent_node)
    end
  end
end
