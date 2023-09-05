defmodule LexerTest do
  use ExUnit.Case
  doctest Lexer

  test "greets the world" do
    assert Lexer.hello() == :world
  end

  test "tokenizes simple syntax symbols" do
    input = "=+(){},;"

    expected_tokens = [
      :assign,
      :plus,
      :lparen,
      :rparen,
      :lsquirly,
      :rsquirly,
      :comma,
      :semicolon,
      :eof
    ]

    assert Lexer.init(input) == expected_tokens
  end

  test "tokenizes variable declarations" do
    input = """
      let five = 5;
      let ten = 10;
    """

    expected_tokens = [
      :let,
      {:ident, "five"},
      :assign,
      {:int, "5"},
      :semicolon,
      :let,
      {:ident, "ten"},
      :assign,
      {:int, "10"},
      :semicolon,
      :eof
    ]

    assert Lexer.init(input) == expected_tokens
  end

  test "tokenizes operators" do
    input = """
    !-/*5;
    5 < 10 > 5;
    """

    expected_tokens = [
      :bang,
      :minus,
      :slash,
      :asterisk,
      {:int, "5"},
      :semicolon,
      {:int, "5"},
      :less_than,
      {:int, "10"},
      :greater_than,
      {:int, "5"},
      :semicolon,
      :eof
    ]

    assert Lexer.init(input) == expected_tokens
  end

  test "tokenizes if/else statement" do
    input = """
    if (5 < 10) {
      return true;
    } else {
      return false;
    }
    """

    expected_tokens = [
      :if,
      :lparen,
      {:int, "5"},
      :less_than,
      {:int, "10"},
      :rparen,
      :lsquirly,
      :return,
      true,
      :semicolon,
      :rsquirly,
      :else,
      :lsquirly,
      :return,
      false,
      :semicolon,
      :rsquirly,
      :eof
    ]

    assert Lexer.init(input) == expected_tokens
  end

  test "tokenizes equivalence operators" do
    input = """
    10 == 10;
    11 != 10;
    """

    expected_tokens = [
      {:int, "10"},
      :equal,
      {:int, "10"},
      :semicolon,
      {:int, "11"},
      :not_equal,
      {:int, "10"},
      :semicolon,
      :eof
    ]

    assert Lexer.init(input) == expected_tokens
  end

  test "tokenizes return statements" do
    input = """
    return 5;
    return 10;
    return add(15);
    """

    expected_tokens = [
      :return,
      {:int, "5"},
      :semicolon,
      :return,
      {:int, "10"},
      :semicolon,
      :return,
      {:ident, "add"},
      :lparen,
      {:int, "15"},
      :rparen,
      :semicolon,
      :eof
    ]

    assert Lexer.init(input) == expected_tokens
  end

  test "tokenizes identifiers with keywords as part of the name" do
    input = """
    let returnfoo = 1;
    return returnfoo;
    """

    expected_tokens = [
      :let,
      {:ident, "returnfoo"},
      :assign,
      {:int, "1"},
      :semicolon,
      :return,
      {:ident, "returnfoo"},
      :semicolon,
      :eof
    ]

    assert Lexer.init(input) == expected_tokens
  end
end
