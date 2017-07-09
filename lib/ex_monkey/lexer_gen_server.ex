defmodule ExMonkey.Lexer.GenServer do
  use GenServer

  alias ExMonkey.Token
  alias ExMonkey.Lexer.Helper

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

  def handle_call({:next_token}, from, state) do
    if state[:char] |> Helper.is_letter_or_digit? do
      new_state = state |> get_identifier("")
      with :skip <- new_state[:char] |> Token.from_string do
        handle_call({:next_token}, from, new_state)
      else
        char -> {:reply, char, new_state |> read_char}
      end
    else
      new_state = read_char(state)
      with :skip <- state[:char] |> Token.from_string do
        handle_call({:next_token}, from, new_state)
      else
        char -> {:reply, char, new_state}
      end
    end
  end

  def get_identifier(state, identifier) do
    char = state[:input] |> get_char(state[:position])
    position = state[:position] + 1
    read_position = state[:read_position] + 1
    new_state =  state |> Map.merge(%{char: identifier <> char, position: position, read_position: read_position})
    unless state[:input] |> String.codepoints() |> Enum.at(state[:read_position]) |> Helper.is_letter_or_digit? do
      state |> Map.merge(%{char: identifier <> char})
    else
      get_identifier(new_state, identifier <> char)
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

  def get_char(input, position) do
    if position + 1 > input |> String.length() do
      :eof
    else
      input |> String.codepoints |> Enum.at(position)
    end
  end
end
