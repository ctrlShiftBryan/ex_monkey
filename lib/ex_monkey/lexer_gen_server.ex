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

  def get_identifier(state) do
    get_identifier(state, state[:char])
  end
  def get_identifier(state, identifier) do
    if state |> keep_going?() do
      state
      |> update_char(identifier)
      |> increment_position()
      |> get_identifier()
    else
      state
      |> update_char(identifier)
    end
  end

  def update_char(state, identifier) do
    current_char = state[:input] |> get_char(state[:position])
    new_char = identifier <> current_char
    state |> Map.merge(%{char: new_char})
  end

  def increment_position(state) do
    position = state[:position] + 1
    read_position = state[:read_position] + 1
    state |> Map.merge(%{position: position, read_position: read_position})
  end

  def keep_going?(state) do
    state[:input] |> String.codepoints() |> Enum.at(state[:read_position]) |> Helper.is_letter_or_digit?
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
