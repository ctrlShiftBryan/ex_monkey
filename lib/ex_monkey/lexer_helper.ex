defmodule ExMonkey.Lexer.Helper do
  def is_letter?(" "), do: false
  def is_letter?(:eof), do: false
  def is_letter?(char) do
    char |> String.match?(~r/^[A-Za-z_]+$/)
  end
end
