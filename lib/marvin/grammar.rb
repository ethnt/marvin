module Marvin
  class Grammar
    Type = /^(int|string|boolean)$/
    Digit = /(\d+)/
    StringExpr = /("[^"]*")/
    Equality = /(==)/
    Inequality = /(!=)/
    Char = /[a-z]/
    Assignment = /(=)/
    Boolop = /(==|!=)/
    Boolval = /(true|false)/
    Intop = /(\+)/
    BlockBegin = /({)/
    BlockEnd = /(})/
    ProgramEnd = /(\$)/
    IfStatement = /(if)/
    Space = /\s/
    CharList = /([a-z]+)/
    AnyChar = /(\S)/
    OpenParenthesis = /\(/
    CloseParenthesis = /\)/

    Delimiters = Regexp.union([
      Space,
      CharList,
      Digit,
      StringExpr,
      Equality,
      Inequality,
      AnyChar
    ]).freeze

    Specifications = [
      Type,
      Digit,
      CharList,
      Char,
      Assignment,
      Boolop,
      Boolval,
      BlockBegin,
      BlockEnd,
      OpenParenthesis,
      CloseParenthesis,
      ProgramEnd
    ].freeze
  end
end
