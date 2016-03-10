module Marvin

  # The Parser will verify the syntax of the found Tokens.
  class Parser
    attr_accessor :tokens, :config

    # Creates a new Parser with a given Lexer and configuration.
    #
    # @param [Array<Marvin::Token>] tokens A bunch of tokens.
    # @param [Marvin::Configuration] config Configuration instance.
    # @return [Marvin::Parser] An un-run parser.
    def initialize(tokens, config = Marvin::Configuration.new)
      @tokens = tokens
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
      # tokens (flip-flops are used in 1 out of every 10m lines of Ruby).
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
    # @param [Boolean] fail_out Whether or not to fail out if we don't find a
    #                           match.
    # @param [Boolean] advance Whether or not to advance the pointer if a match
    #                          is found.
    # @return [Boolean] Whether or not the kind matches.
    def match?(kind, fail_out: true, advance: true)

      # We have a match.
      if current_token.kind == kind
        @counter += 1 if advance

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

      parse_block!
      match?(:program_end)

      # If there are more tokens, that means there is more than one program in
      # this file.
      # if current_token
      #   parse_program!
      # end
    end

    # Parses a block.
    #
    #   Block ::= { StatementList }
    def parse_block!
      @config.logger.info('  Parsing block...')

      match?(:block_begin)
      parse_statement_list!
      match?(:block_end)
    end

    # Parses a statement list.
    #
    #   StatementList ::= Statement StatementList
    #                 ::= ε
    def parse_statement_list!
      @config.logger.info('  Parsing statement list...')

      kinds = [:print, :char, :type, :while, :if_statement, :block_begin]

      if match_any?(kinds)
        parse_statement!
        parse_statement_list!
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
    def parse_statement!
      @config.logger.info('  Parsing statement...')

      if match?(:print, fail_out: false, advance: false)
        return parse_print_statement!
      end

      if match?(:char, fail_out: false, advance: false)
        return parse_assignment_statement!
      end

      if match?(:type, fail_out: false, advance: false)
        return parse_var_decl!
      end

      if match?(:while, fail_out: false, advance: false)
        return parse_while_statement!
      end

      if match?(:if_statement, fail_out: false, advance: false)
        return parse_if_statement!
      end

      if match?(:block_begin, fail_out: false, advance: false)
        return parse_block!
      end

      fail Marvin::Error::ParseError.new(token, [:print, :char, :type, :while, :if_statement, :block_begin])
    end

    # Parses a print statement.
    #
    #   PrintStatement ::== print ( Expr )
    def parse_print_statement!
      @config.logger.info('  Parsing print statement...')

      match?(:print, fail_out: false)
      match?(:open_parenthesis, fail_out: false)
      parse_expr!
      match?(:close_parenthesis, fail_out: false)
    end

    # Parses an assignment statement.
    #
    #   AssignmentStatement ::== Id = Expr
    def parse_assignment_statement!
      @config.logger.info('  Parsing assignment statement...')

      parse_id!
      match?(:assignment)
      parse_expr!
    end

    # Parses a variable declaration.
    #
    #   VarDecl ::== type Id
    def parse_var_decl!
      @config.logger.info('  Parsing variable declaration...')

      match?(:type)
      parse_id!
    end

    # Parses a while statement.
    #
    #   WhileStatement ::== while BooleanExpr Block
    def parse_while_statement!
      @config.logger.info('  Parsing while statement...')

      match?(:while)
      parse_boolean_expr!
      parse_block!
    end

    # Parses an if statement.
    #
    #   IfStatement ::== if BooleanExpr Block
    def parse_if_statement!
      @config.logger.info('  Parsing while statement...')

      match?(:if_statement)
      parse_boolean_expr!
      parse_block!
    end

    # Parses an expression.
    #
    #   Expr ::== IntExpr
    #        ::== StringExpr
    #        ::== BooleanExpr
    #        ::== Id
    def parse_expr!
      @config.logger.info('  Parsing expression...')

      if match?(:digit, fail_out: false, advance: false)
        parse_int_expr!
      elsif match?(:string, fail_out: false, advance: false)
        parse_string_expr!
      elsif match?(:boolval, fail_out: false, advance: false) || match?(:open_parenthesis, fail_out: false, advance: false)
        parse_boolean_expr!
      elsif match?(:char, fail_out: false, advance: false)
        parse_id!
      else
        fail
      end
    end

    # Parses an integer expression.
    #
    #   IntExpr ::== digit intop Expr
    #           ::== digit
    def parse_int_expr!
      @config.logger.info('  Parsing integer expression...')

      match?(:digit)

      return parse_expr! if match?(:intop, fail_out: false)
    end

    # Parses a string expression.
    #
    #   StringExpr ::= " CharList "
    def parse_string_expr!
      @config.logger.info('  Parsing string expression...')

      match?(:string)
    end

    # Parses a boolean expression.
    #
    #   BooleanExpr ::= ( Expr boolop Expr )
    #               ::= boolval
    def parse_boolean_expr!
      @config.logger.info('  Parsing boolean expression...')

      if match?(:open_parenthesis, fail_out: false, advance: false)
        match?(:open_parenthesis)
        parse_expr!
        match?(:boolop)
        parse_expr!
        match?(:close_parenthesis)
      else
        match?(:boolval)
      end
    end

    # Parses an identifier.
    #
    #   Id ::== char
    def parse_id!
      @config.logger.info('  Parsing identifier...')

      match?(:char)
    end
  end
end
