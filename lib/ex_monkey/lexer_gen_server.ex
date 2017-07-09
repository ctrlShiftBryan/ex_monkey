defmodule ExMonkey.Lexer.GenServer do
  use GenServer

  alias ExMonkey.Token

  def start_link(name, input) do
    init_state = %{
      input: input,
      position: 0,
      read_position: 1,
      char: input |> String.codepoints |> Enum.at(0)
    }
    GenServer.start_link(__MODULE__, init_state, name: name)
  end


  def next_token(name) do
    GenServer.call(name, {:next_token})
  end

  # Server (callbacks)
  def handle_call({:next_token}, _from, state) do
    new_state = read_char(state)

    {:reply,
     state[:char] |> Token.from_string,
     new_state}
  end

  def read_char(state) do
    %{
      input: state[:input],
      position: state[:read_position],
      read_position: state[:read_position] + 1,
      char: state[:input] |> get_char(state[:read_position])
    }
  end

  def get_char(input, position) do
    if position + 1 > input |> String.length() do
      :eof
    else
      input |> String.codepoints |> Enum.at(position)
    end
  end
end
