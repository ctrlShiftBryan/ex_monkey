defmodule ExMonkey.Lexer.Helper do
  def is_letter?(" "), do: false
  def is_letter?(:eof), do: false
  def is_letter?(char) do
    char |> String.match?(~r/^[A-Za-z_]+$/)
  end

  def is_digit?(" "), do: false
  def is_digit?(:eof), do: false
  def is_digit?(char) do
    char |> String.match?(~r/^[0-9]+$/)
  end

  def is_letter_or_digit?(char) do
    char |> is_letter? || char |> is_digit?
  end
end
