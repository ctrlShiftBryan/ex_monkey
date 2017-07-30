defmodule ExMonkey.LetStatement do

  alias ExMonkey.Token

  defstruct [token: %Token{}, name: nil, value: nil]

  def expression_node(_i) do
  end

  def token_literal(i) do
    i.token.liternal
  end
end
