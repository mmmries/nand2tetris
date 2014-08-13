defmodule Jack.Statements do
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
  def statement(tree, [{:keyword,"if"}|tail]) do
    [{:symbol,"("}|tail] = tail
    children = [keyword: "if", symbol: "("]
    {children,tail} = Jack.Expressions.expression(children,tail)
    [{:symbol,")"},{:symbol,"{"}|tail] = tail
    children = children ++ [symbol: ")", symbol: "{"]
    {children,tail} = parse(children,tail)
    [{:symbol,"}"}|tail] = tail
    children = children ++ [symbol: "}"]
    subtree = [ifStatement: children]
    {tree ++ subtree, tail}
  end
  def statement(tree, [{:keyword,"while"}|tail]) do
    [{:symbol,"("}|tail] = tail
    children = [keyword: "while", symbol: "("]
    {children,tail} = Jack.Expressions.expression(children,tail)
    [{:symbol,")"},{:symbol,"{"}|tail] = tail
    children = children ++ [symbol: ")", symbol: "{"]
    {children,tail} = parse(children,tail)
    [{:symbol,"}"}|tail] = tail
    children = children ++ [symbol: "}"]
    subtree = [whileStatement: children]
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
