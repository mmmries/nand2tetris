defmodule Jack.Compiler do
  import Jack.Tokenizer, only: [tokenize: 1]
  import Jack.Parser, only: [parse: 1]
  import Jack.SymbolTable, only: [resolve: 1]
  import Jack.Instruction, only: [from_ast: 1]

  def compile(class_string) do
    class_string |>
      tokenize |>
      parse |>
      resolve |>
      Jack.Collapser.collapse |>
      from_ast
  end

end
