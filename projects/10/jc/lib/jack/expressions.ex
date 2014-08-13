defmodule Jack.Expressions do
  def parse(tree, [{:symbol,"("}|tail]) do
    {children, tail} = list_item([], tail)
    subtree = [symbol: "(", expressionList: children, symbol: ")"]
    {tree ++ subtree, tail}
  end

  def expression(tree,tail) do
    {children, tail} = term([], tail)
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

  defp term(tree,[{:identifier,id}|tail]) do
    subtree = [{:term, [{:identifier, id}]}]
    {tree ++ subtree, tail}
  end
  defp term(tree,[{:integerConstant,num}|tail]) do
    subtree = [term: [integerConstant: num]]
    {tree ++ subtree, tail}
  end
end
