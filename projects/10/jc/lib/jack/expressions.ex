defmodule Jack.Expressions do
  def parse(tree, [{:symbol,"("}|tail]) do
    {children, tail} = list_item([], tail)
    subtree = [symbol: "(", expressionList: children, symbol: ")"]
    {tree ++ subtree, tail}
  end

  def expression(tree,tail) do
    {children, tail} = terms_and_operators([], tail)
    subtree = [{:expression, children}]
    {tree ++ subtree, tail}
  end

  defp list_item(tree,[{:symbol,")"}|tail]), do: {tree, tail}
  defp list_item(tree,[{:symbol,","}|tail]) do
    tree = tree ++ [symbol: ","]
    {tree, tail} = expression(tree, tail)
    list_item(tree, tail)
  end
  defp list_item(tree,tail) do
    {tree, tail} = expression(tree, tail)
    list_item(tree, tail)
  end

  defp term(tree,[{:symbol,"("}|tail]) do
    {children,tail} = expression([symbol: "("],tail)
    [{:symbol,")"}|tail] = tail
    children = children ++ [symbol: ")"]
    subtree = [term: children]
    {tree ++ subtree, tail}
  end
  defp term(tree,[{:identifier,id},{:symbol,"("}|tail]) do
    {children,tail} = Jack.Expressions.parse([identifier: id], [{:symbol,"("}|tail])
    subtree = [term: children]
    {tree ++ subtree, tail}
  end
  defp term(tree,[{:identifier,receiver},{:symbol,"."},{:identifier,m}|tail]) do
    children = [identifier: receiver, symbol: ".", identifier: m]
    {children,tail} = Jack.Expressions.parse(children,tail)
    subtree = [term: children]
    {tree ++ subtree, tail}
  end
  defp term(tree,[{:keyword,k}|tail]) when (k in ["true","false","null","this"]) do
    subtree = [term: [keyword: k]]
    {tree ++ subtree, tail}
  end
  defp term(tree,[{:identifier,id}|tail]) do
    subtree = [{:term, [{:identifier, id}]}]
    {tree ++ subtree, tail}
  end
  defp term(tree,[{:integerConstant,num}|tail]) do
    subtree = [term: [integerConstant: num]]
    {tree ++ subtree, tail}
  end

  defp terms_and_operators(tree,[{:symbol,op}|tail]) when (op in ["+","-","*","/","&","|","<",">","="]) do
    terms_and_operators(tree ++ [symbol: op], tail)
  end
  defp terms_and_operators(tree,[{:symbol,op}|tail]) when (op in ["(","-","~"]) do
    tail = [{:symbol, op}|tail]
    {tree,tail} = term(tree,tail)
    terms_and_operators(tree,tail)
  end
  defp terms_and_operators(tree,[{type,val}|tail]) when(type in [:identifier, :keyword, :integerConstant]) do
    {tree,tail} = term(tree,[{type,val}|tail])
    terms_and_operators(tree,tail)
  end
  defp terms_and_operators(tree,tail), do: {tree,tail}
end
