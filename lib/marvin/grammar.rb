module Marvin
  class Grammar
    BLOCK_BEGIN = /({)/
    BLOCK_END = /(})/
    PROGRAM_END = /(\$)/
    OPEN_PARENTHESIS = /\(/
    CLOSE_PARENTHESIS = /\)/

    TYPE = /(int|string|boolean)/

    DIGIT = /(\d+)/
    CHAR = /[a-z]/
    BOOLVAL = /(true|false)/
    STRING = /("[a-z]+")/

    EQUALITY = /(==)/
    INEQUALITY = /(!=)/
    ASSIGNMENT = /(=)/
    BOOLOP = /(==|!=)/
    INTOP = /(\+)/

    WHILE = /(while)/
    PRINT = /(print)/
    IF_STATEMENT = /(if)/
    ELSE_STATEMENT = /(else)/

    SPACE = /(\s)/
    NEWLINE = /(\n)/

    SPECIFICATIONS = {
      block_begin: BLOCK_BEGIN,
      block_end: BLOCK_END,
      type: TYPE,
      digit: DIGIT,
      boolval: BOOLVAL,
      boolop: BOOLOP,
      string: STRING,
      print: PRINT,
      else_statement: ELSE_STATEMENT,
      if_statement: IF_STATEMENT,
      while: WHILE,
      char: CHAR,
      new_line: NEWLINE,
      assignment: ASSIGNMENT,
      open_parenthesis: OPEN_PARENTHESIS,
      close_parenthesis: CLOSE_PARENTHESIS,
      program_end: PROGRAM_END
    }.freeze
  end
end
