defmodule ExMonkey.Parser.GenServer do

  def start_link(name, _input) do
    init_state = %{
      # lexer: input
      # input: input,
      # position: 0,
      # read_position: 1,
      # char: input |> String.codepoints |> Enum.at(0)
    }
    GenServer.start_link(__MODULE__, init_state, name: name)
  end
end
