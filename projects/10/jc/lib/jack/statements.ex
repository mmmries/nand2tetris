defmodule Jack.Statements do
  def parse(tree, tail) do
    {children, tail} = statement([], tail)
    {children, tail} = statement(children, tail)
    {children, tail} = statement(children, tail)
    {children, tail} = statement(children, tail)
    subtree = [{:statements, children}]
    {tree ++ subtree, tail}
  end

  def statement(tree, [{:keyword,"let"},{:identifier,name},{:symbol,"="}|tail]) do
    children = [{:keyword,"let"},{:identifier,name},{:symbol,"="}]
    {children, tail} = Jack.Expressions.expression(children, tail)
    [{:symbol,";"}|tail] = tail
    children = children ++ [{:symbol,";"}]
    subtree = [{:letStatement, children}]
    {tree ++ subtree, tail}
  end
  def statement(tree, [{:keyword,"do"}|tail]) do
    {children, tail} = sub_call([{:keyword,"do"}], tail)
    [{:symbol,";"}|tail] = tail
    children = children ++ [{:symbol,";"}]
    subtree = [{:doStatement, children}]
    {tree ++ subtree, tail}
  end
  def statement(tree, [{:keyword,"return"},{:symbol,";"}|tail]) do
    children = [{:keyword,"return"},{:symbol,";"}]
    subtree = [{:returnStatement, children}]
    {tree ++ subtree, tail}
  end
  def statement(tree, [{:keyword,"return"}|tail]) do
    {children, tail} = Jack.Expressions.expression([keyword: "return"], tail)
    [{:symbol,";"}|tail] = tail
    children = children ++ [symbol: ";"]
    subtree = [returnStatement: children]
    {tree ++ subtree, tail}
  end
  def statement(tree,tail), do: {tree, tail}

  defp sub_call(tree, [{:identifier,target},{:symbol,"."},{:identifier,m}|tail]) do
    children = [{:identifier,target},{:symbol,"."},{:identifier,m}]
    {children, tail} = Jack.Expressions.parse(children,tail)
    {tree ++ children, tail}
  end
  defp sub_call(tree,[{:identifier,m}|tail]) do
    {children, tail} = Jack.Expressions.parse([identifier: m],tail)
    {tree ++ children, tail}
  end
end
