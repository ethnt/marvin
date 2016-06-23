
# line 1 "./lib/marvin/lexer.rl"
=begin

# line 92 "./lib/marvin/lexer.rl"

=end

module Marvin

  # A Ragel-based lexer.
  class Lexer
    attr_accessor :tokens

    def initialize(source)
      @source = source
      @tokens = []

      
# line 21 "./lib/marvin/lexer.rb"
class << self
	attr_accessor :_lexer_actions
	private :_lexer_actions, :_lexer_actions=
end
self._lexer_actions = [
	0, 1, 0, 1, 1, 1, 2, 1, 
	3, 1, 4, 1, 5, 1, 6, 1, 
	7, 1, 8, 1, 9, 1, 10, 1, 
	11, 1, 12, 1, 13, 1, 14, 1, 
	15, 1, 16, 1, 17, 1, 18, 1, 
	19, 1, 20, 1, 21
]

class << self
	attr_accessor :_lexer_key_offsets
	private :_lexer_key_offsets, :_lexer_key_offsets=
end
self._lexer_key_offsets = [
	0, 0, 1, 3, 4, 5, 6, 7, 
	8, 9, 10, 11, 12, 13, 14, 15, 
	16, 17, 18, 19, 20, 21, 22, 23, 
	47, 49, 50, 51, 52, 54, 55, 56, 
	57
]

class << self
	attr_accessor :_lexer_trans_keys
	private :_lexer_trans_keys, :_lexer_trans_keys=
end
self._lexer_trans_keys = [
	61, 34, 92, 111, 108, 101, 97, 110, 
	108, 115, 101, 116, 105, 110, 116, 114, 
	105, 110, 103, 117, 105, 108, 101, 32, 
	33, 34, 36, 40, 41, 43, 45, 61, 
	98, 102, 105, 112, 115, 116, 119, 123, 
	125, 9, 13, 48, 57, 97, 122, 48, 
	57, 61, 111, 97, 102, 110, 114, 116, 
	114, 104, 0
]

class << self
	attr_accessor :_lexer_single_lengths
	private :_lexer_single_lengths, :_lexer_single_lengths=
end
self._lexer_single_lengths = [
	0, 1, 2, 1, 1, 1, 1, 1, 
	1, 1, 1, 1, 1, 1, 1, 1, 
	1, 1, 1, 1, 1, 1, 1, 18, 
	0, 1, 1, 1, 2, 1, 1, 1, 
	1
]

class << self
	attr_accessor :_lexer_range_lengths
	private :_lexer_range_lengths, :_lexer_range_lengths=
end
self._lexer_range_lengths = [
	0, 0, 0, 0, 0, 0, 0, 0, 
	0, 0, 0, 0, 0, 0, 0, 0, 
	0, 0, 0, 0, 0, 0, 0, 3, 
	1, 0, 0, 0, 0, 0, 0, 0, 
	0
]

class << self
	attr_accessor :_lexer_index_offsets
	private :_lexer_index_offsets, :_lexer_index_offsets=
end
self._lexer_index_offsets = [
	0, 0, 2, 5, 7, 9, 11, 13, 
	15, 17, 19, 21, 23, 25, 27, 29, 
	31, 33, 35, 37, 39, 41, 43, 45, 
	67, 69, 71, 73, 75, 78, 80, 82, 
	84
]

class << self
	attr_accessor :_lexer_trans_targs
	private :_lexer_trans_targs, :_lexer_trans_targs=
end
self._lexer_trans_targs = [
	23, 0, 23, 0, 2, 4, 23, 5, 
	23, 6, 23, 7, 23, 23, 23, 9, 
	23, 10, 23, 23, 23, 23, 23, 13, 
	23, 14, 23, 23, 23, 16, 23, 17, 
	23, 18, 23, 23, 23, 10, 23, 21, 
	23, 22, 23, 23, 23, 23, 1, 2, 
	23, 23, 23, 23, 23, 25, 26, 27, 
	28, 29, 30, 31, 32, 23, 23, 23, 
	24, 23, 0, 24, 23, 23, 23, 3, 
	23, 8, 23, 23, 11, 23, 12, 23, 
	15, 23, 19, 23, 20, 23, 23, 23, 
	23, 23, 23, 23, 23, 23, 23, 23, 
	23, 23, 23, 23, 23, 23, 23, 23, 
	23, 23, 23, 23, 23, 23, 23, 23, 
	23, 23, 23, 0
]

class << self
	attr_accessor :_lexer_trans_actions
	private :_lexer_trans_actions, :_lexer_trans_actions=
end
self._lexer_trans_actions = [
	19, 0, 31, 0, 0, 0, 43, 0, 
	43, 0, 43, 0, 43, 29, 43, 0, 
	43, 0, 43, 21, 43, 29, 43, 0, 
	43, 0, 43, 17, 43, 0, 43, 0, 
	43, 0, 43, 29, 43, 0, 43, 0, 
	43, 0, 43, 25, 43, 35, 0, 0, 
	11, 13, 15, 23, 23, 0, 5, 5, 
	5, 5, 5, 5, 5, 7, 9, 35, 
	0, 33, 0, 0, 37, 19, 39, 0, 
	41, 0, 41, 27, 0, 41, 0, 41, 
	0, 41, 0, 41, 0, 41, 43, 43, 
	43, 43, 43, 43, 43, 43, 43, 43, 
	43, 43, 43, 43, 43, 43, 43, 43, 
	43, 43, 37, 39, 41, 41, 41, 41, 
	41, 41, 41, 0
]

class << self
	attr_accessor :_lexer_to_state_actions
	private :_lexer_to_state_actions, :_lexer_to_state_actions=
end
self._lexer_to_state_actions = [
	0, 0, 0, 0, 0, 0, 0, 0, 
	0, 0, 0, 0, 0, 0, 0, 0, 
	0, 0, 0, 0, 0, 0, 0, 1, 
	0, 0, 0, 0, 0, 0, 0, 0, 
	0
]

class << self
	attr_accessor :_lexer_from_state_actions
	private :_lexer_from_state_actions, :_lexer_from_state_actions=
end
self._lexer_from_state_actions = [
	0, 0, 0, 0, 0, 0, 0, 0, 
	0, 0, 0, 0, 0, 0, 0, 0, 
	0, 0, 0, 0, 0, 0, 0, 3, 
	0, 0, 0, 0, 0, 0, 0, 0, 
	0
]

class << self
	attr_accessor :_lexer_eof_trans
	private :_lexer_eof_trans, :_lexer_eof_trans=
end
self._lexer_eof_trans = [
	0, 0, 0, 106, 106, 106, 106, 106, 
	106, 106, 106, 106, 106, 106, 106, 106, 
	106, 106, 106, 106, 106, 106, 106, 0, 
	107, 108, 115, 115, 115, 115, 115, 115, 
	115
]

class << self
	attr_accessor :lexer_start
end
self.lexer_start = 23;
class << self
	attr_accessor :lexer_first_final
end
self.lexer_first_final = 23;
class << self
	attr_accessor :lexer_error
end
self.lexer_error = 0;

class << self
	attr_accessor :lexer_en_main
end
self.lexer_en_main = 23;


# line 106 "./lib/marvin/lexer.rl"
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

      
# line 215 "./lib/marvin/lexer.rb"
begin
	p ||= 0
	pe ||= data.length
	cs = lexer_start
	ts = nil
	te = nil
	act = 0
end

# line 123 "./lib/marvin/lexer.rl"
      
# line 227 "./lib/marvin/lexer.rb"
begin
	_klen, _trans, _keys, _acts, _nacts = nil
	_goto_level = 0
	_resume = 10
	_eof_trans = 15
	_again = 20
	_test_eof = 30
	_out = 40
	while true
	_trigger_goto = false
	if _goto_level <= 0
	if p == pe
		_goto_level = _test_eof
		next
	end
	if cs == 0
		_goto_level = _out
		next
	end
	end
	if _goto_level <= _resume
	_acts = _lexer_from_state_actions[cs]
	_nacts = _lexer_actions[_acts]
	_acts += 1
	while _nacts > 0
		_nacts -= 1
		_acts += 1
		case _lexer_actions[_acts - 1]
			when 1 then
# line 1 "NONE"
		begin
ts = p
		end
# line 261 "./lib/marvin/lexer.rb"
		end # from state action switch
	end
	if _trigger_goto
		next
	end
	_keys = _lexer_key_offsets[cs]
	_trans = _lexer_index_offsets[cs]
	_klen = _lexer_single_lengths[cs]
	_break_match = false
	
	begin
	  if _klen > 0
	     _lower = _keys
	     _upper = _keys + _klen - 1

	     loop do
	        break if _upper < _lower
	        _mid = _lower + ( (_upper - _lower) >> 1 )

	        if data[p].ord < _lexer_trans_keys[_mid]
	           _upper = _mid - 1
	        elsif data[p].ord > _lexer_trans_keys[_mid]
	           _lower = _mid + 1
	        else
	           _trans += (_mid - _keys)
	           _break_match = true
	           break
	        end
	     end # loop
	     break if _break_match
	     _keys += _klen
	     _trans += _klen
	  end
	  _klen = _lexer_range_lengths[cs]
	  if _klen > 0
	     _lower = _keys
	     _upper = _keys + (_klen << 1) - 2
	     loop do
	        break if _upper < _lower
	        _mid = _lower + (((_upper-_lower) >> 1) & ~1)
	        if data[p].ord < _lexer_trans_keys[_mid]
	          _upper = _mid - 2
	        elsif data[p].ord > _lexer_trans_keys[_mid+1]
	          _lower = _mid + 2
	        else
	          _trans += ((_mid - _keys) >> 1)
	          _break_match = true
	          break
	        end
	     end # loop
	     break if _break_match
	     _trans += _klen
	  end
	end while false
	end
	if _goto_level <= _eof_trans
	cs = _lexer_trans_targs[_trans]
	if _lexer_trans_actions[_trans] != 0
		_acts = _lexer_trans_actions[_trans]
		_nacts = _lexer_actions[_acts]
		_acts += 1
		while _nacts > 0
			_nacts -= 1
			_acts += 1
			case _lexer_actions[_acts - 1]
when 2 then
# line 1 "NONE"
		begin
te = p+1
		end
when 3 then
# line 25 "./lib/marvin/lexer.rl"
		begin
te = p+1
 begin 
      emit(:T_LBRACKET, data, ts, te)
     end
		end
when 4 then
# line 29 "./lib/marvin/lexer.rl"
		begin
te = p+1
 begin 
      emit(:T_RBRACKET, data, ts, te)
     end
		end
when 5 then
# line 33 "./lib/marvin/lexer.rl"
		begin
te = p+1
 begin 
      emit(:T_EOP, data, ts, te)
     end
		end
when 6 then
# line 37 "./lib/marvin/lexer.rl"
		begin
te = p+1
 begin 
      emit(:T_LPAREN, data, ts, te)
     end
		end
when 7 then
# line 41 "./lib/marvin/lexer.rl"
		begin
te = p+1
 begin 
      emit(:T_RPAREN, data, ts, te)
     end
		end
when 8 then
# line 45 "./lib/marvin/lexer.rl"
		begin
te = p+1
 begin 
      emit(:T_PRINT, data, ts, te)
     end
		end
when 9 then
# line 49 "./lib/marvin/lexer.rl"
		begin
te = p+1
 begin 
      emit(:T_BOOLOP, data, ts, te)
     end
		end
when 10 then
# line 53 "./lib/marvin/lexer.rl"
		begin
te = p+1
 begin 
      emit(:T_BOOLVAL, data, ts, te)
     end
		end
when 11 then
# line 57 "./lib/marvin/lexer.rl"
		begin
te = p+1
 begin 
      emit(:T_INTOP, data, ts, te)
     end
		end
when 12 then
# line 61 "./lib/marvin/lexer.rl"
		begin
te = p+1
 begin 
      emit(:T_WHILE, data, ts, te)
     end
		end
when 13 then
# line 65 "./lib/marvin/lexer.rl"
		begin
te = p+1
 begin 
      emit(:T_IF, data, ts, te)
     end
		end
when 14 then
# line 69 "./lib/marvin/lexer.rl"
		begin
te = p+1
 begin 
      emit(:T_TYPE, data, ts, te)
     end
		end
when 15 then
# line 81 "./lib/marvin/lexer.rl"
		begin
te = p+1
 begin 
      emit(:T_STRING, data, ts, te)
     end
		end
when 16 then
# line 85 "./lib/marvin/lexer.rl"
		begin
te = p+1
 begin 
      emit(:T_IDENT, data, ts, te)
     end
		end
when 17 then
# line 89 "./lib/marvin/lexer.rl"
		begin
te = p+1
		end
when 18 then
# line 73 "./lib/marvin/lexer.rl"
		begin
te = p
p = p - 1; begin 
      emit(:T_INTEGER, data, ts, te)
     end
		end
when 19 then
# line 77 "./lib/marvin/lexer.rl"
		begin
te = p
p = p - 1; begin 
      emit(:T_ASSIGN, data, ts, te)
     end
		end
when 20 then
# line 85 "./lib/marvin/lexer.rl"
		begin
te = p
p = p - 1; begin 
      emit(:T_IDENT, data, ts, te)
     end
		end
when 21 then
# line 85 "./lib/marvin/lexer.rl"
		begin
 begin p = ((te))-1; end
 begin 
      emit(:T_IDENT, data, ts, te)
     end
		end
# line 481 "./lib/marvin/lexer.rb"
			end # action switch
		end
	end
	if _trigger_goto
		next
	end
	end
	if _goto_level <= _again
	_acts = _lexer_to_state_actions[cs]
	_nacts = _lexer_actions[_acts]
	_acts += 1
	while _nacts > 0
		_nacts -= 1
		_acts += 1
		case _lexer_actions[_acts - 1]
when 0 then
# line 1 "NONE"
		begin
ts = nil;		end
# line 501 "./lib/marvin/lexer.rb"
		end # to state action switch
	end
	if _trigger_goto
		next
	end
	if cs == 0
		_goto_level = _out
		next
	end
	p += 1
	if p != pe
		_goto_level = _resume
		next
	end
	end
	if _goto_level <= _test_eof
	if p == eof
	if _lexer_eof_trans[cs] > 0
		_trans = _lexer_eof_trans[cs] - 1;
		_goto_level = _eof_trans
		next;
	end
end
	end
	if _goto_level <= _out
		break
	end
	end
	end

# line 124 "./lib/marvin/lexer.rl"

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
