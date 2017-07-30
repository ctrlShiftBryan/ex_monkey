defmodule ExMonkey.Program do
  defstruct [statements: []]

  def token_literal(p) do
    if p |> Enum.count > 0 do
      (p |> hd()).token_literal
    else
      ""
    end
  end
end
