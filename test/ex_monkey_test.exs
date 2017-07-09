defmodule ExMonkeyTest do
  use ExUnit.Case
  doctest ExMonkey

  alias ExMonkey.{Lexer, Token}

  test "basic tokens parse" do
    input = "=+(){},;"
    Lexer.new(input)

    expected = [%Token{literal: "=", type: :assign},
                %Token{literal: "+", type: :plus},
                %Token{literal: "(", type: :lparen},
                %Token{literal: ")", type: :rparen},
                %Token{literal: "{", type: :lbrace},
                %Token{literal: "}", type: :rbrace},
                %Token{literal: ",", type: :coma},
                %Token{literal: ";", type: :semicolon},
                %Token{literal: :eof, type: :eof}]

    results = for _ <- 1..(expected |> Enum.count), do: Lexer.next_token

    assert results == expected
  end
end
