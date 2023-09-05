defmodule Lexer do
  @type keyword_token ::
          :function
          | :let
          | :if
          | :else
          | :return
          | true
          | false

  @type tokentype ::
          :assign
          | :plus
          | :minus
          | :lparen
          | :rparen
          | :lbrace
          | :rbrace
          | :comma
          | :semicolon
          | :function
          | :let
          | {:ident, String.t()}
          | {:int, String.t()}
          | {:illegal, String.t()}

  # private macros?
  defguardp is_whitespace(c) when c in ~c[ \n\t]
  defguardp is_letter(c) when c in ?a..?z or c in ?A..?Z or c == ?_
  defguardp is_digit(c) when c in ?0..?9

  @spec init(String.t()) :: [tokentype()]
  def init(input) when is_binary(input) do
    lex(input, [])
  end

  # Base case
  @spec lex(input :: String.t(), [tokentype()]) :: [tokentype()]
  defp lex(<<>>, tokens) do
    [:eof | tokens] |> Enum.reverse()
  end

  # ignores whitespace as it encounters it
  defp lex(<<c::8, rest::binary>>, tokens) when is_whitespace(c) do
    lex(rest, tokens)
  end

  # recurses through input and tokenizes the characters as it goes
  defp lex(input, tokens) do
    {token, rest} = tokenize(input)
    lex(rest, [token | tokens])
  end

  # matches
  @spec tokenize(input :: String.t()) :: {tokentype(), rest :: String.t()}
  defp tokenize(<<"==", rest::binary>>), do: {:equal, rest}
  defp tokenize(<<"!=", rest::binary>>), do: {:not_equal, rest}
  defp tokenize(<<";", rest::binary>>), do: {:semicolon, rest}
  defp tokenize(<<",", rest::binary>>), do: {:comma, rest}
  defp tokenize(<<"(", rest::binary>>), do: {:lparen, rest}
  defp tokenize(<<")", rest::binary>>), do: {:rparen, rest}
  defp tokenize(<<"{", rest::binary>>), do: {:lbrace, rest}
  defp tokenize(<<"}", rest::binary>>), do: {:rbrace, rest}
  defp tokenize(<<"=", rest::binary>>), do: {:assign, rest}
  defp tokenize(<<"+", rest::binary>>), do: {:plus, rest}
  defp tokenize(<<"-", rest::binary>>), do: {:minus, rest}
  defp tokenize(<<"!", rest::binary>>), do: {:bang, rest}
  defp tokenize(<<"/", rest::binary>>), do: {:slash, rest}
  defp tokenize(<<"*", rest::binary>>), do: {:asterisk, rest}
  defp tokenize(<<">", rest::binary>>), do: {:greater_than, rest}
  defp tokenize(<<"<", rest::binary>>), do: {:less_than, rest}
  defp tokenize(<<c::8, rest::binary>>) when is_letter(c), do: read_identifier(rest, <<c>>)
  defp tokenize(<<c::8, rest::binary>>) when is_digit(c), do: read_number(rest, <<c>>)
  defp tokenize(<<c::8, rest::binary>>), do: {{:illegal, <<c>>}, rest}

  @spec read_identifier(String.t(), iodata()) :: {tokentype(), String.t()}
  defp read_identifier(<<c::8, rest::binary>>, acc) when is_letter(c) do
    read_identifier(rest, [acc | <<c>>])
  end

  defp read_identifier(rest, acc) do
    {IO.iodata_to_binary(acc) |> tokenize_word(), rest}
  end

  @spec read_number(String.t(), iodata()) :: {tokentype(), String.t()}
  defp read_number(<<c::8, rest::binary>>, acc) when is_digit(c) do
    read_number(rest, [acc | <<c>>])
  end

  defp read_number(rest, acc) do
    {{:int, IO.iodata_to_binary(acc)}, rest}
  end

  @spec tokenize_word(String.t()) :: keyword_token() | {:ident, String.t()}
  defp tokenize_word("fn"), do: :function
  defp tokenize_word("let"), do: :let
  defp tokenize_word("if"), do: :if
  defp tokenize_word("else"), do: :else
  defp tokenize_word("true"), do: true
  defp tokenize_word("false"), do: false
  defp tokenize_word("return"), do: :return
  defp tokenize_word(ident), do: {:ident, ident}

  def hello() do
    :world
  end
end
