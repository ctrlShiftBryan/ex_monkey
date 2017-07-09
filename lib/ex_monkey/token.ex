defmodule ExMonkey.Token do
  defstruct [:type, :literal]

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
      %ExMonkey.Token{type: unquote(token), literal: unquote(string)}
    end
  end

  def from_string(_), do: :illegal
end
