defmodule ExMonkey.Lexer do
  def new(input) do
    ExMonkey.Lexer.GenServer.start_link(:lexer, input)
  end

  def next_token() do
    ExMonkey.Lexer.GenServer.next_token(:lexer)
  end
end
