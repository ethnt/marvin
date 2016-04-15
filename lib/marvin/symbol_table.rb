require 'pry'

module Marvin

  # Contains scopes and their child variable types, keys, and values.
  class SymbolTable < Tree

    def from_ast(ast)
      @ast = ast

      @root = Marvin::Node.new(@ast.root.content.clone)

      prune_children(@ast.root, @root)

      self
    end

    def prune_children(ast_node, table_node)
      ast_node.children.each_with_index do |ast_child, i|
        next unless ast_child.is_production? || ast_child.is_token?

        if ast_child.is_production?
          production = ast_child.content

          whitelist = %w( Block )

          next_node = table_node

          if whitelist.include?(production.name)
            scope = Marvin::Scope.from_production(production)
            scope_node = Marvin::Node.new(scope)
            table_node.add(scope_node)
            next_node = scope_node
          end
        end

        if ast_child.is_token?
          token = ast_child.content

          whitelist = %i( type digit boolean string char )

          if whitelist.include?(token.kind)
            case token.kind

            # This means we have a type declaration
            when :type
              # The name should be in the next token.
              name = ast_node.children[i + 1].content.lexeme
              type = token.lexeme

              # Set the new identifier with the name and type
              identifier = Marvin::Identifier.new(name, type)

              # If there's an identifier, let's add it!
              if identifier
                node = Marvin::Node.new(identifier)

                table_node.add(node)
              end

            # This means we have an identifier
            when :char
              name = token.lexeme
              value = ast_node.children[i + 1].content.lexeme if ast_node.children[i + 1]

              # Look for a identifier in this node's children (it's children and
              # parentage)
              if identifier = table_node.children_hash.keys.include?(name)
                identifier.content.attributes[:value] = value

              # Otherwise look in parentage
              elsif identifier = table_node.find_in_parentage(name)
                binding.pry
                identifier = identifier.dup
                identifier.content.attributes[:value] = value

                table_node.add(identifier)
              else
                # ERROR!
              end

            # This means we have a value
            else

            end
          end


          next_node = table_node
        end

        prune_children(ast_child, next_node) if ast_child.has_children?
      end
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
