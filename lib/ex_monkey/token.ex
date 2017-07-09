defmodule ExMonkey.Token do
  defstruct [:type, :literal]
  alias ExMonkey.Token

  @tokens %{
    illegal:   "ILLEGAL",
    eof:       :eof,


    # identifiers and literals
    ident:     "IDENT",
    int:       "INT",


    # operators
    assign:    "=",
    plus:      "+",


    # delimiters
    coma:      ",",
    semicolon: ";",

    lparen:    "(",
    rparen:    ")",
    lbrace:    "{",
    rbrace:    "}",

    # keywords
    function:  "FUNCTION",
    let:       "LET"
  }


  for {token, string} <- @tokens do
    def from_string(unquote(string)) do
      %Token{type: unquote(token), literal: unquote(string)}
    end
  end

  def from_string("let"), do: %Token{type: :let, literal: "let"}
  def from_string(" "), do: :ignore
  def from_string("\n"), do: :ignore
  def from_string(ident), do: %Token{type: :ident, literal: ident}

end
