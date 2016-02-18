module Marvin

  # Describes the grammar of our programming language.
  class Grammar

    # The different types of lexemes in the language.
    Lexemes = {
      block_begin: /({)/,
      block_end: /(})/,
      type: /(int|string|boolean)/,
      digit: /(\d+)/,
      boolval: /(true|false)/,
      boolop: /(==|!=)/,
      intop: /\+/,
      string: /"([^"]*)"/,
      print: /(print)/,
      else_statement: /(else)/,
      if_statement: /(if)/,
      while: /(while)/,
      char: /[a-z]/,
      new_line: /(\n)/,
      assignment: /(=)/,
      open_parenthesis: /\(/,
      close_parenthesis: /\)/,
      program_end: /(\$)/
    }.freeze
  end
end
