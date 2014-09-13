defmodule Mix.Tasks.Benchmark do
  use Mix.Task
  import Jack.Tokenizer, only: [tokenize: 1]
  import Jack.Parser, only: [parse: 1]
  import Jack.SymbolTable, only: [resolve: 1]

  def run(_argv) do
    str = File.read! "test/fixtures/Square/Square.jack"
    tokens = str |> tokenize
    parsed = tokens |> parse

    IO.puts "tokenizing"
    Benchwarmer.benchmark &( &1 |> tokenize ), str

    IO.puts "parse"
    Benchwarmer.benchmark &( &1 |> parse ), [tokens]

    IO.puts "symbol resolution"
    Benchwarmer.benchmark &( &1 |> resolve ), parsed
  end
end
