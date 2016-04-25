require 'pry'

module Marvin

  # Contains scopes and their child variable types, keys, and values.
  class SymbolTable < Tree

    def initialize(config = nil)
      @config = config

      super(nil)
    end

    def from_ast(ast)
      @ast = ast.root

      @root = Marvin::Scope.new('<Scope>')

      traverse_ast(@ast, @root)
    end

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

        binding.pry if scope.nil?

        traverse_ast(child, next_scope)
      end
    end

    # If we reach a new block, let's create a new scope.
    # if production.name == 'Block'
    #
    # @param [Marvin::Node] node The node to search through.
    # @param [Marvin::Scope] scope The current scope.
    def handle_block!(node, scope)
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
      type = node.children.first.content.lexeme
      name = node.children.last.content.lexeme

      if scope.find_identifier(name, current_only: true)
        token = node.children.last.content

        @config.logger.warning("Redeclared identifier at #{token.lexeme} on line #{token.attributes[:line]} at character #{token.attributes[:char]}")
      end

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
      return Marvin::Error::ScopeError.new(node.children.first.content) unless identifier

      declared_type = identifier.type
      given_type = node.children.last.resolve_type(scope)

      return Marvin::Error::TypeError.new(node.children.last, declared_type, given_type) if declared_type != given_type

      identifier = Marvin::Node.new(Marvin::Identifier.new(name: name, type: given_type))

      scope.add(identifier)

      scope
    end

    # Print out the tree.
    #
    # @return [nil]
    def print!
      puts "foo"

      @root.print_tree(@root.node_depth, nil, lambda { |node, prefix| puts "#{prefix} #{node.to_s}" })

      nil
    end
  end
end
