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
                %Token{literal: ",", type: :comma},
                %Token{literal: ";", type: :semicolon},
                %Token{literal: :eof, type: :eof}]

    results = for _ <- 1..(expected |> Enum.count), do: Lexer.next_token

    assert results == expected
  end

  test "identifiers, keywords and numbers" do

    input = """
    let five = 5;

    let ten = 10;

    let add = fn(x, y){
      x + y;
            };

    let result = add (five,ten);
    """
    Lexer.new(input)
    expected = [%Token{type: :let,        literal: "let"},
                %Token{type: :ident,      literal: "five"},
                %Token{type: :assign,     literal: "="},
                %Token{type: :int,        literal: "5"},
                %Token{type: :semicolon,  literal: ";"},
                %Token{type: :let,        literal: "let"},
                %Token{type: :ident,      literal: "ten"},
                %Token{type: :assign,     literal: "="},
                %Token{type: :int,        literal: "10"},
                %Token{type: :semicolon,  literal: ";"},
                %Token{type: :let,        literal: "let"},
                %Token{type: :ident,      literal: "add"},
                %Token{type: :assign,     literal: "="},
                %Token{type: :function,   literal: "fn"},
                %Token{type: :lparen,     literal: "("},
                %Token{type: :ident,      literal: "x"},
                %Token{type: :comma,      literal: ","},
                %Token{type: :ident,      literal: "y"},
                %Token{type: :rparen,     literal: ")"},
                %Token{type: :lbrace,     literal: "{"},
                %Token{type: :ident,      literal: "x"},
                %Token{type: :plus,       literal: "+"},
                %Token{type: :ident,      literal: "y"},
                %Token{type: :semicolon,  literal: ";"},
                %Token{type: :rbrace,     literal: "}"},
                %Token{type: :semicolon,  literal: ";"},
                %Token{type: :let,        literal: "let"},
                %Token{type: :ident,      literal: "result"},
                %Token{type: :assign,     literal: "="},
                %Token{type: :ident,      literal: "add"},
                %Token{type: :lparen,     literal: "("},
                %Token{type: :ident,      literal: "five"},
                %Token{type: :comma,      literal: ","},
                %Token{type: :ident,      literal: "ten"},
                %Token{type: :rparen,     literal: ")"},
                %Token{type: :semicolon,  literal: ";"},
                %Token{type: :eof,        literal: :eof}]


    results = for _ <- 1..(expected |> Enum.count), do: Lexer.next_token

    assert {results |> Enum.count, results} == { expected |> Enum.count, expected}
  end

  test "more tokens" do

    input = """
    !-/*5;
    5 < 10 > 5;
    """
    Lexer.new(input)

    expected = [%Token{type: :exclamation,  literal: "!"},
                %Token{type: :minus,        literal: "-"},
                %Token{type: :divide,       literal: "/"},
                %Token{type: :multiply,     literal: "*"},
                %Token{type: :int,          literal: "5"},
                %Token{type: :semicolon,    literal: ";"},
                %Token{type: :int,          literal: "5"},
                %Token{type: :less_than,    literal: "<"},
                %Token{type: :int,          literal: "10"},
                %Token{type: :greater_than, literal: ">"},
                %Token{type: :int,          literal: "5"},
                %Token{type: :semicolon,    literal: ";"},
                %Token{type: :eof,          literal: :eof}]


    results = for _ <- 1..(expected |> Enum.count), do: Lexer.next_token

    assert {results |> Enum.count, results} == { expected |> Enum.count, expected}
  end

  test "more keywords" do

    input = """
    if (5 < 10) {
      return true;
    } else {
      return false;
    }
    """

    Lexer.new(input)

    expected = [%Token{type: :if,        literal: "if"},
                %Token{type: :lparen,    literal: "("},
                %Token{type: :int,       literal: "5"},
                %Token{type: :less_than, literal: "<"},
                %Token{type: :int,       literal: "10"},
                %Token{type: :rparen,    literal: ")"},
                %Token{type: :lbrace,    literal: "{" },
                %Token{type: :return,    literal: "return"},
                %Token{type: :true,      literal: "true"},
                %Token{type: :semicolon, literal: ";"},
                %Token{type: :rbrace,    literal: "}"},
                %Token{type: :else,      literal: "else"},
                %Token{type: :lbrace,    literal: "{" },
                %Token{type: :return,    literal: "return"},
                %Token{type: :false,     literal: "false"},
                %Token{type: :semicolon, literal: ";"},
                %Token{type: :rbrace,    literal: "}"},
                %Token{type: :eof,       literal: :eof}]


    results = for _ <- 1..(expected |> Enum.count), do: Lexer.next_token

    assert {results |> Enum.count, results} == { expected |> Enum.count, expected}
  end

  test "double identifiers" do

    input = """
    10 == 10;
    10 != 9;
    """

    Lexer.new(input)

    expected = [%Token{type: :int,       literal: "10"},
                %Token{type: :equal,     literal: "=="},
                %Token{type: :int,       literal: "10"},
                %Token{type: :semicolon, literal: ";"},
                %Token{type: :int,       literal: "10"},
                %Token{type: :not_equal, literal: "!="},
                %Token{type: :int,       literal: "9"},
                %Token{type: :semicolon, literal: ";"},
                %Token{type: :eof,       literal: :eof}]


    results = for _ <- 1..(expected |> Enum.count), do: Lexer.next_token

    assert {results |> Enum.count, results} == { expected |> Enum.count, expected}
  end
end
