# encoding: UTF-8

%w(
  version
  configuration
  runner
  command
  logger
  error
  tree
  token
  lexer
  production
  node
  scope
  identifier
  cst
  ast
  symbol_table
  parser
).each { |file| require_relative "marvin/#{file}" }

# This module contains all of the classes belonging to Marvin.
module Marvin
end
