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
    GenServer.call(name, {:next_token}, 5_000_000)
  end

  require IEx
  # Server (callbacks)
  def handle_call({:next_token}, from, state) do
    IO.inspect(state[:char])
    if state[:char] |> is_letter? do
      new_state = state |> get_identifier("")
      with :ignore <- new_state[:char] |> Token.from_string do
        handle_call({:next_token}, from, new_state)
      else
        char -> {:reply, char, new_state |> read_char}
      end
    else
      new_state = read_char(state)
      with :ignore <- state[:char] |> Token.from_string do
        handle_call({:next_token}, from, new_state)
      else
        char -> {:reply, char, new_state}
      end
    end
  end

  def get_identifier(state, identifier) do
    x = state[:input] |> get_char(state[:position])
    x2 = read_char(state)
    new_state =  x2 |> Map.merge(%{char: identifier <> x})
    if state[:input] |> String.codepoints() |> Enum.at(state[:read_position]) |> is_letter? do
      get_identifier(new_state, identifier <> x)
    else
      new_state
    end
  end

  def read_char(state) do
    %{
      input: state[:input],
      position: state[:read_position],
      read_position: state[:read_position] + 1,
      char: state[:input] |> get_char(state[:read_position])
    }
  end

  def is_letter?(" "), do: false
  def is_letter?(:eof), do: false
  def is_letter?(char) do
    char |> String.match?(~r/[A-Za-z_]/)
  end

  def get_char(input, position) do
    if position + 1 > input |> String.length() do
      :eof
    else
      input |> String.codepoints |> Enum.at(position)
    end
  end
end
