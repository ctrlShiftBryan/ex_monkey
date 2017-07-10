defmodule ExMonkey.Lexer do
  alias ExMonkey.Lexer.GenServer

  def new(input) do
    GenServer.start_link(:lexer, input)
  end

  def next_token() do
    GenServer.next_token(:lexer)
  end

  def stop() do
    GenServer.stop(:lexer)
  end

  def reset(input) do
    GenServer.reset(:lexer, input)
  end
end
