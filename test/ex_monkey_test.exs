defmodule ExMonkeyTest do
  use ExUnit.Case
  doctest ExMonkey

  alias ExMonkey.Lexer
  test "basic tokens parse" do
    input = "=+(){},;"
    Lexer.new(input)

    expected = [%ExMonkey.Token{literal: "=", type: :assign},
                %ExMonkey.Token{literal: "+", type: :plus},
                %ExMonkey.Token{literal: "(", type: :lparen},
                %ExMonkey.Token{literal: ")", type: :rparen},
                %ExMonkey.Token{literal: "{", type: :lbrace},
                %ExMonkey.Token{literal: "}", type: :rbrace},
                %ExMonkey.Token{literal: ",", type: :coma},
                %ExMonkey.Token{literal: ";", type: :semicolon},
                %ExMonkey.Token{literal: :eof, type: :eof}]

    results = for _ <- 1..(expected |> Enum.count), do: Lexer.next_token

    assert results == expected
  end
end
