require 'pry'

module Marvin

  # Contains scopes and their child variable types, keys, and values.
  class SymbolTable < Tree

    # Create a new symbol table.
    #
    # @param [Marvin::Configuration] config A configuration instance.
    # @return [Marvin::SymbolTable] A new symbol table.
    def initialize(config = nil)
      @config = config

      super(nil)
    end

    # Generate a symbol table from an AST.
    #
    # @param [Marvin::AST] ast An AST.
    # @return [Marvin::SymbolTable] Your brand new symbol table!
    def from_ast(ast)
      @ast = ast.root

      @root = Marvin::Scope.new('<Scope>')

      traverse_ast(@ast, @root)
    end

    # Traverse the children of an AST node to get symbol table information.
    #
    # @param [Marvin::Node] node The current node of the AST.
    # @param [Marvin::Scope] scope The current node of the symbol table.
    # @return [Marvin::SymbolTable] The current symbol table.
    def traverse_ast(node, scope)
      node.children.each do |child|
        next unless child.production?

        # Handle the type of production to get the next scope.
        next_scope =  case child.content.name
                      when 'Block'
                        handle_block!(child, scope)
                      when 'VariableDeclaration'
                        handle_variable_declaration!(child, scope)
                      when 'Assignment'
                        handle_assignment!(child, scope)
                      else
                        scope
                      end

        traverse_ast(child, next_scope)
      end
    end

    # If we reach a new block, let's create a new scope.
    # if production.name == 'Block'
    #
    # @param [Marvin::Node] _ Ignore me.
    # @param [Marvin::Scope] scope The current scope.
    def handle_block!(_, scope)
      nested_scope = Marvin::Scope.new('<Scope>')

      # Add the nested scope to the current scope and set the current scope
      # to the nested scope.
      scope.add(nested_scope)

      nested_scope
    end

    # If we reach a variable declaration, we're adding a new identifier to
    # the current scope.
    #
    # @param [Marvin::Node] node The node to search through.
    # @param [Marvin::Scope] scope The current scope.
    def handle_variable_declaration!(node, scope)

      # The type is the first part of the variable declaration.
      type = node.children.first.content.lexeme

      # The name is the last part of the variable declaration.
      name = node.children.last.content.lexeme

      # Check and make sure that the we're not redeclaring the identifier in the
      # same scope.
      if scope.find_identifier(name, current_only: true)
        token = node.children.last.content

        return Marvin::Error::RedeclaredIdentifierError.new(token)
      end

      # We'll create a new identifier in the current scope.
      identifier = Marvin::Node.new(Marvin::Identifier.new(name: name, type: type))

      scope.add(identifier)

      scope
    end

    # If we reach an assignment statement, we're going to check the type.
    #
    # @param [Marvin::Node] node The node to search through.
    # @param [Marvin::Scope] scope The current scope.
    def handle_assignment!(node, scope)
      name = node.children.first.content.lexeme

      # Find the previous variable declaration.
      identifier = scope.find_identifier(name)

      # If we can't find an identifier, throw an error!
      return Marvin::Error::UndeclaredIdentifierError.new(node.children.first.content) unless identifier

      # The declared type is what the type is supposed to be.
      declared_type = identifier.type

      # The given type is the type of the actual value.
      given_type = node.children.last.resolve_type(scope)

      # If the given type returns nil, that means it's an un-assigned identifier.
      if given_type.is_a?(Marvin::Identifier)
        @config.logger.warning("Assigning identifier #{identifier.name} to another unassigned identifier #{given_type.name} on line #{node.children.last.content.attributes[:line]} at character #{node.children.last.content.attributes[:char]}")

        given_type = given_type.type
      end

      # If they don't agree, that's a type error!
      return Marvin::Error::TypeError.new(node.children.last, declared_type, given_type) if declared_type != given_type

      # Set the identifier to be declared.
      identifier.assigned = true

      scope
    end
  end
end
