module Marvin

  # The Parser will verify the syntax of the found tokens.
  class Parser
    attr_accessor :tokens, :configuration

    # Creates a new Parser with a given Lexer and configuration.
    #
    # @param [[Marvin::Token]] tokens A bunch of tokens.
    # @param [Marvin::Configuration] configuration Configuration instance.
    # @return [Marvin::Parser] An un-run parser.
    def initialize(tokens, configuration = Marvin::Configuration.new)
      @tokens = tokens
      @configuration = configuration
    end

    # Will parse the tokens given.
    #
    # @return [Boolean] Whether the source is valid or not.
    def parse!
      @counter = 0

      parse_program!

      true
    end

    protected

    # Checks whether or not the current token matches the expected kind.
    # TODO: Argument on whether or not to fail out
    #
    # @param [Symbol] kind The expected kind.
    # @param [Boolean] fail_out Whether or not to fail out if we don't find a
    #                           match.
    # @return [Boolean] Whether or not the kind matches.
    def match?(kind, fail_out = true)
      # We have a match.
      if current_token.kind == kind
        @counter = @counter + 1

        true
      else
        if fail_out
          fail Marvin::ParserError.new(current_token, kind)
        else
          false
        end
      end
    end

    # Match against one of the given kinds.
    #
    # @param [[Symbol]] kinds The expected kinds to match against.
    #
    # @return [Boolean] Whether one of the kinds match.
    def match_one?(kinds)
      kinds.each do |kind|
        if match?(kind, false)
          return true
        end
      end

      false
    end

    # Checks if all the given arguments are true.
    #
    # @param [[Boolean]] args The operations to check.
    # @return [Boolean] If they're all true or not.
    def all_true?(args)
      (args.uniq.length == 1) && (args.uniq.first == true)
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
      parse_block!
      match?(:program_end)
    end

    # Parses a block.
    #
    #  Block ::= { StatementList }
    def parse_block!
      match?(:block_begin)
      parse_statement_list!
      match?(:block_end)
    end

    # Parses a statement list.
    #
    #   StatementList ::= Statement StatementList
    #                 ::= ε
    def parse_statement_list!
      parse_print_statement!
    end

    # Parses a print statement.
    #
    #   PrintStatement ::== print ( Expr )
    def parse_print_statement!
      match?(:print, false)
      match?(:open_parenthesis, false)
      parse_expr!
      match?(:close_parenthesis, false)
    end

    # Parses an expression.
    #
    #   Expr ::== IntExpr
    #        ::== StringExpr
    #        ::== BooleanExpr
    #        ::== Id
    def parse_expr!
      parse_int_expr!
    end

    # Parses an integer expression.
    #
    #   IntExpr ::== digit intop Expr
    #           ::== digit
    def parse_int_expr!
      match?(:digit)
      
      if match?(:intop, false)
        return parse_expr!
      end
    end
  end
end
