defmodule Jack.Compiler do
  import Jack.Tokenizer, only: [tokenize: 1]
  import Jack.Parser, only: [parse: 1]
  import Jack.SymbolTable, only: [resolve: 1]

  def compile(class_string) do
    class_string |>
      tokenize |>
      parse |>
      resolve |>
      Jack.Collapser.collapse |>
      a2i([])
  end

  # AST to Instructions
  defp a2i([],_path), do: []
  defp a2i([{:term,t1},{:symbol,op},{:term,t2}|tail], path) do
    op = op_to_instruction(op)
    is1 = a2i(t1, [:term|path])
    is2 = a2i(t2, [:term|path])
    tail = a2i(tail, path)
    is1 ++ is2 ++ op ++ tail
  end
  defp a2i([{:symbol,"~"},{:term,t}|tail], path) do
    is = a2i(t,[:term,path])
    is ++ ["not"] ++ a2i(tail,path)
  end
  defp a2i([{:symbol,"-"},{:term,t}|tail], path) do
    is = a2i(t,[:term,path])
    is ++ ["neg"] ++ a2i(tail,path)
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
  defp a2i([{:keyword, "this"}],[:term|_tail]) do
    ["push pointer 0"]
  end
  defp a2i([{:identifier,%{category: "var", index: i}}|_ast], [:term|_tail]) do
    ["push local #{i}"]
  end
  defp a2i([{:identifier,%{category: "argument", index: i}}|_ast], [:term|_tail]) do
    ["push argument #{i}"]
  end
  defp a2i([{:identifier,%{category: "var", index: i}}|tail], [:letStatement|_p] = path) do
    instructions = a2i(tail,path)
    instructions ++ ["pop local #{i}"]
  end
  defp a2i([{:identifier,%{category: "argument", index: i}}|tail], [:letStatement|_p] = path) do
    instructions = a2i(tail,path)
    instructions ++ ["pop argument #{i}"]
  end
  defp a2i([{:identifier,%{category: "field", index: i}}|tail], [:letStatement|_p] = path) do
    instructions = a2i(tail,path)
    instructions ++ ["pop this #{i}"]
  end

  defp a2i([{:identifier,%{name: name, class: class, category: "subroutine", definition: true, local_vars: vars}}|tail], path) do
    instructions = a2i(tail,path)
    ["function #{class}.#{name} #{vars}"|instructions]
  end
  defp a2i([{:identifier,%{name: name, class: class, category: "constructor", definition: true, local_vars: lv, instance_vars: iv}}|tail], path) do
    instructions = a2i(tail,path)
    ["function #{class}.#{name} #{lv}", "push constant #{iv}", "call Memory.alloc 1", "pop pointer 0"|instructions]
  end
  defp a2i([{:identifier,%{name: name, class: class, category: "subroutine", definition: false, numArgs: numArgs, receiver: receiver}}|tail], path) do
    receiver_setup = a2i([identifier: receiver], [:term | path])
    setup = a2i(tail, path)
    receiver_setup ++ setup ++ ["call #{class}.#{name} #{numArgs}"]
  end
  defp a2i([{:identifier,%{name: name, class: class, category: "subroutine", definition: false, numArgs: numArgs}}|tail], path) do
    setup = a2i(tail, path)
    setup ++ ["call #{class}.#{name} #{numArgs}"]
  end
  defp a2i([{:doStatement,statement}|tail], path) do
    setup_and_call = a2i(statement,[:doStatement,path])
    rest = a2i(tail,path)
    setup_and_call ++ ["pop temp 0"] ++ rest
  end
  defp a2i([{:ifStatement,if_map}|tail], path) do
    %{
      condition: condition,
      false_statements: false_statements,
      true_statements: true_statements,
      index: index} = if_map
    instructions = a2i(condition, [:ifStatement|path])
    instructions = instructions ++ ["if-goto IF_TRUE#{index}","goto IF_FALSE#{index}","label IF_TRUE#{index}"]
    instructions = instructions ++ a2i(true_statements,[:ifStatement,path])
    instructions = instructions ++ ["goto IF_END#{index}","label IF_FALSE#{index}"]
    instructions = instructions ++ a2i(false_statements,[:ifStatement,path])
    instructions = instructions ++ ["label IF_END#{index}"]
    instructions ++ a2i(tail, path)
  end
  defp a2i([{:whileStatement, while_map}|tail], path) do
    %{
      condition: condition,
      statements: statements,
      index: index} = while_map
    condition = a2i(condition, [:whileStatement|path])
    statements = a2i(statements,[:whileStatement,path])
    tail = a2i(tail,path)
    ["label WHILE_EXP#{index}"] ++ condition ++ ["not","if-goto WHILE_END#{index}"] ++ statements ++ ["goto WHILE_EXP#{index}","label WHILE_END#{index}"] ++ tail
  end
  defp a2i([{:returnStatement,val}|tail], path) do
    return_value = return_value(val)
    instructions = a2i(tail,path)
    return_value ++ ["return"|instructions]
  end
  defp a2i([{type, list}|tail],path) when is_list(list) do
    sub_instructions = a2i(list,[type|path])
    tail_instructions = a2i(tail,path)
    sub_instructions ++ tail_instructions
  end
  defp a2i([_head|tail],path), do: a2i(tail,path)

  defp op_to_instruction("+"), do: ["add"]
  defp op_to_instruction("-"), do: ["sub"]
  defp op_to_instruction("*"), do: ["call Math.multiply 2"]
  defp op_to_instruction("<"), do: ["lt"]
  defp op_to_instruction(">"), do: ["gt"]
  defp op_to_instruction("="), do: ["eq"]
  defp op_to_instruction("&"), do: ["and"]
  defp op_to_instruction("|"), do: ["or"]

  defp return_value([keyword: "return", symbol: ";"]), do: ["push constant 0"]
  defp return_value(ast), do: a2i(ast,[:returnStatement])
end
