defmodule ExMonkey.Repl do
  alias ExMonkey.Lexer
  def main(_args) do
    input = IO.gets "moneky repl> "
    Lexer.new(input)

    tokens = do_tokens([])
    for token <- tokens do
      IO.inspect token
    end
    Lexer.stop()
    main([])
  end

  def do_tokens(tokens) do
    with %{literal: :eof} = token <- Lexer.next_token() do
      tokens ++ [token]
    else
      token -> do_tokens(tokens ++ [token])
    end
  end
end
