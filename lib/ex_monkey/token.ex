defmodule ExMonkey.Token do
  defstruct [:type, :literal]
  alias ExMonkey.Token
  alias ExMonkey.Lexer.Helper

  @tokens %{
    eof:          :eof,

    # operators
    exclamation:  "!",
    assign:       "=",
    plus:         "+",
    minus:        "-",
    divide:       "/",
    multiply:     "*",

    # delimiters
    comma:        ",",
    semicolon:    ";",


    greater_than: ">",
    less_than:    "<",

    lparen:       "(",
    rparen:       ")",
    lbrace:       "{",
    rbrace:       "}",

    true:          "true",
    false:         "false",

    # keywords
    return:       "return",
    function:     "fn",
    if:           "if",
    else:         "else",
    let:          "let",

    equal:        "==",
    not_equal:    "!="
  }


  for {token, string} <- @tokens do
    def from_string(unquote(string)) do
      %Token{type: unquote(token), literal: unquote(string)}
    end
  end

  def from_string(" "), do: :skip
  def from_string("\t"), do: :skip
  def from_string("\n"), do: :skip
  def from_string("\r"), do: :skip

  def from_string(ident) do
    cond do
      Helper.is_letter?(ident) -> %Token{type: :ident, literal: ident}
      Helper.is_digit?(ident) -> %Token{type: :int, literal: ident}
      true -> %Token{type: :illegal, literal: ident}
    end
  end
end
