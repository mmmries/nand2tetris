defmodule Mix.Tasks.Benchmark do
  use Mix.Task
  import Jack.Tokenizer, only: [tokenize: 1]
  import Jack.Parser, only: [parse: 1]

  def run(_argv) do
    str = File.read! "test/fixtures/Square/Square.jack"
    Benchwarmer.benchmark &tokenize_and_parse/1, str
  end

  defp tokenize_and_parse(str) do
    str |> tokenize |> parse
  end
end
