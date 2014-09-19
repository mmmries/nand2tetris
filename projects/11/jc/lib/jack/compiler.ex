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
  defp a2i([{:term,t1},{:symbol,op},{:term,t2}|tail], path) do
    op = op_to_instruction(op)
    is1 = a2i(t1, [:term|path])
    is2 = a2i(t2, [:term|path])
    is1 ++ is2 ++ op
  end
  defp a2i([{:integerConstant, i}],[:term|_tail]) do
    ["push constant #{i}"]
  end
  defp a2i([{:keyword, "true"}],[:term|_tail]) do
    ["push constant 0","not"]
  end
  defp a2i([{:keyword, "false"}],[:term|_tail]) do
    ["push constant 0"]
  end
  defp a2i([{:identifier,%{category: "var", index: i}}|tail], [:letStatement|_p] = path) do
    instructions = a2i(tail,path)
    instructions ++ ["pop local #{i}"]
  end
  defp a2i([{:identifier,%{name: name, class: class, category: "subroutine", definition: true, local_vars: vars}}|tail], path) do
    instructions = a2i(tail,path)
    ["function #{class}.#{name} #{vars}"|instructions]
  end
  defp a2i([{:identifier,%{name: name, class: class, category: "subroutine", definition: false}}|tail], path) do
    setup = a2i(tail, path)
    setup ++ ["call #{class}.#{name} 1"]
  end
  defp a2i([{:doStatement,statement}|tail], path) do
    setup_and_call = a2i(statement,[:doStatement,path])
    rest = a2i(tail,path)
    setup_and_call ++ ["pop temp 0"] ++ rest
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

  defp op_to_instruction("+"), do: ["add"]
  defp op_to_instruction("*"), do: ["call Math.multiply 2"]
end
