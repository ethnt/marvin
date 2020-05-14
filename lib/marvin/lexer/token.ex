defmodule Marvin.Lexer.Token do
  defstruct [:lexeme, :kind, attributes: %{}]

  @type t :: %__MODULE__{
          lexeme: String.t(),
          kind: atom,
          attributes: map
        }

  @spec new(map) :: Token.t()
  def new(attrs) do
  end
end
