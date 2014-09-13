defmodule Jack.Compiler do
  import Jack.Tokenizer, only: [tokenize: 1]
  import Jack.Parser, only: [parse: 1]
  import Jack.SymbolTable, only: [generate: 1]

  def compile(class_string) do
    class_string |>
      tokenize |>
      parse |>
      generate |>
      ast_to_instructions |>
      Enum.join("\n")
  end

  def ast_to_instructions([]), do: []
  def ast_to_instructions([head|tail]), do: ast_to_instructions(tail)
end
