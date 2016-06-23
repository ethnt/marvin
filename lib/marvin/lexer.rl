=begin
%%{
  machine lexer;

  block_begin = '{';
  block_end   = '}';
  program_end = '$';
  open_paren  = '(';
  close_paren = ')';
  while       = 'while';
  iff         = 'if';
  type        = 'int'|'string'|'boolean';
  quote       = '"';
  not_dquote_or_escape = [^"\\];
  integer     = ([0-9]+);
  assignment  = '=';
  boolop      = '=='|'!=';
  boolval     = 'true'|'false';
  intop       = '+'|'-';
  identifier  = [a-z];
  print_cmd   = 'print';

  main := |*

    block_begin => {
      emit(:T_LBRACKET, data, ts, te)
    };

    block_end => {
      emit(:T_RBRACKET, data, ts, te)
    };

    program_end => {
      emit(:T_EOP, data, ts, te)
    };

    open_paren => {
      emit(:T_LPAREN, data, ts, te)
    };

    close_paren => {
      emit(:T_RPAREN, data, ts, te)
    };

    print_cmd => {
      emit(:T_PRINT, data, ts, te)
    };

    boolop => {
      emit(:T_BOOLOP, data, ts, te)
    };

    boolval => {
      emit(:T_BOOLVAL, data, ts, te)
    };

    intop => {
      emit(:T_INTOP, data, ts, te)
    };

    while => {
      emit(:T_WHILE, data, ts, te)
    };

    iff => {
      emit(:T_IF, data, ts, te)
    };

    type => {
      emit(:T_TYPE, data, ts, te)
    };

    integer => {
      emit(:T_INTEGER, data, ts, te)
    };

    assignment => {
      emit(:T_ASSIGN, data, ts, te)
    };

    quote (not_dquote_or_escape)* quote => {
      emit(:T_STRING, data, ts, te)
    };

    identifier => {
      emit(:T_IDENT, data, ts, te)
    };

    space;

  *|;
}%%
=end

module Marvin

  # A Ragel-based lexer.
  class Lexer
    attr_accessor :tokens

    def initialize(source)
      @source = source
      @tokens = []

      %% write data;
      # % this just fixes our syntax highlighting...
    end

    def emit(token_name, data, ts, te)
      kind = token_name.to_sym
      lexeme = data[ts...te].pack('c*')
      line = line_from_char(ts)
      char = char_on_line(ts)

      @tokens << Marvin::Token.new(kind, lexeme, { line: line, char: char })
    end

    def lex
      data = @source.unpack('c*') if(@source.is_a?(String))
      eof = data.length

      %% write init;
      %% write exec;

      @tokens
    end

    protected

    def line_from_char(char)
      str = @source[0..char]
      str.lines.count
    end

    def char_on_line(char)
      str = @source[0..char]
      last_newline = str.rindex("\n")

      if last_newline
        char - str.rindex("\n")
      else
        char
      end
    end
  end
end
