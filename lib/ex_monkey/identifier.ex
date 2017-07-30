defmodule ExMonkey.Identifier do
  alias ExMonkey.Token

  defstruct [token: %Token{}, value: nil]

  def expression_node(_i) do
  end

  def token_literal(i) do
    i.token.liternal
  end
end
