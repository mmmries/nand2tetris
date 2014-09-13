defmodule Jack.Compiler do
  import Jack.Tokenizer, only: [tokenize: 1]
  import Jack.Parser, only: [parse: 1]
  import Jack.SymbolTable, only: [resolve: 1]

  def compile(class_string) do
    class_string |>
      tokenize |>
      parse |>
      resolve |>
      a2i([])
  end

  # AST to Instructions
  defp a2i([],_path), do: []
  defp a2i([{:identifier,%{name: name, category: "subroutine", definition: true}}|tail], path) do
    instructions = a2i(tail,path)
    ["function Main.#{name} 0"|instructions]
  end
  defp a2i([{:doStatement,statement}|tail], path) do
    setup_and_call = a2i(statement,[:doStatement,path])
    rest = a2i(tail,path)
    [setup_and_call ++ "pop temp 0"|rest]
  end
  defp a2i([{:returnStatement,_val}|tail], path) do
    instructions = a2i(tail,path)
    ["push constant 0","return"|instructions]
  end
  defp a2i([{type, list}|tail],path) when is_list(list) do
    sub_instructions = a2i(list,[type|path])
    tail_instructions = a2i(tail,path)
    sub_instructions ++ tail_instructions
  end
  defp a2i([_head|tail],path), do: a2i(tail,path)
end
