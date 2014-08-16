defmodule Jack.Statements do
  import Jack.Parser, only: [sym: 3]

  def parse(tree, tail) do
    {children, tail} = parse_item([],tail)
    subtree = [{:statements, children}]
    {tree ++ subtree, tail}
  end

  defp parse_item(tree, [{:keyword,k}|tail]) when (k in ["do","if","let","return","while"]) do
    tail = [{:keyword, k}|tail]
    {tree, tail} = statement(tree, tail)
    parse_item(tree, tail)
  end
  defp parse_item(tree, tail), do: {tree, tail}

  def statement(tree, [{:keyword,"let"},{:identifier,name}|tail]) do
    {children, tail} = array_access_or_nil([keyword: "let", identifier: name],tail)
    {children, tail} = sym("=", children, tail)
    {children, tail} = Jack.Expressions.expression(children, tail)
    {children, tail} = sym(";", children, tail)
    subtree = [{:letStatement, children}]
    {tree ++ subtree, tail}
  end
  def statement(tree, [{:keyword,"do"}|tail]) do
    {children, tail} = sub_call([keyword: "do"], tail)
    {children, tail} = sym(";", children, tail)
    subtree = [{:doStatement, children}]
    {tree ++ subtree, tail}
  end
  def statement(tree, [{:keyword,"return"},{:symbol,";"}|tail]) do
    subtree = [returnStatement: [keyword: "return", symbol: ";"]]
    {tree ++ subtree, tail}
  end
  def statement(tree, [{:keyword,"return"}|tail]) do
    {children, tail} = Jack.Expressions.expression([keyword: "return"], tail)
    {children, tail} = sym(";", children, tail)
    subtree = [returnStatement: children]
    {tree ++ subtree, tail}
  end
  def statement(tree, [{:keyword,"if"}|tail]) do
    {children, tail} = sym("(", [keyword: "if"], tail)
    {children,tail} = Jack.Expressions.expression(children,tail)
    {children, tail} = sym(")", children, tail)
    {children, tail} = sym("{", children, tail)
    {children,tail} = parse(children,tail)
    {children, tail} = sym("}", children, tail)
    subtree = [ifStatement: children]
    {tree ++ subtree, tail}
  end
  def statement(tree, [{:keyword,"while"}|tail]) do
    {children, tail} = sym("(",[keyword: "while"], tail)
    {children,tail} = Jack.Expressions.expression(children,tail)
    {children, tail} = sym(")", children, tail)
    {children, tail} = sym("{", children, tail)
    {children,tail} = parse(children,tail)
    {children, tail} = sym("}", children, tail)
    subtree = [whileStatement: children]
    {tree ++ subtree, tail}
  end
  def statement(tree,tail), do: {tree, tail}

  defp sub_call(tree, [{:identifier,target},{:symbol,"."},{:identifier,m}|tail]) do
    children = [identifier: target,symbol: ".",identifier: m]
    {children, tail} = Jack.Expressions.parse(children,tail)
    {tree ++ children, tail}
  end
  defp sub_call(tree,[{:identifier,m}|tail]) do
    {children, tail} = Jack.Expressions.parse([identifier: m],tail)
    {tree ++ children, tail}
  end

  defp array_access_or_nil(tree, [{:symbol,"["}|tail]) do
    {children, tail} = Jack.Expressions.expression([symbol: "["],tail)
    {children, tail} = sym("]", children, tail)
    {tree ++ children, tail}
  end
  defp array_access_or_nil(tree, tail), do: {tree, tail}
end
