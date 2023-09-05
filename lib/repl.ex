defmodule Lexer.Repl do
  @prompt ">>"
  @filepath Path.absname("monkey.txt")

  defp get_input() do
    case IO.gets("#{@prompt}") do
      "quit\n" ->
        IO.puts("Exiting....")

      line ->
        Enum.map(Lexer.init(line), fn x ->
          case x do
            {:ident, y} -> IO.puts("ident: #{y}")
            {:int, y} -> IO.puts("int: #{y}")
            x -> IO.puts(x)
          end
        end)

        get_input()
    end
  end

  def start() do
    IO.puts("Repl Started:")
    get_input()
  end

  def main(args \\ []) do
    start()
  end
end
