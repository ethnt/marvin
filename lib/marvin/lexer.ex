defmodule Marvin.Lexer do
  @moduledoc """
  Takes code and turns it into lexemes.
  """

  @lexemes %{
    T_FUNCTION: ~r/fun/,
    T_BLOCK_BEGIN: ~r/{/,
    T_BLOCK_END: ~r/}/
  }

  alias Marvin.Lexer.Token

  @spec lex(String.t()) :: {:ok, [Token.t()]} | {:error, any}
  def lex(code) do
  end
end
