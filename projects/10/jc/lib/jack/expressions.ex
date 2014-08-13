defmodule Jack.Expressions do
  def expression(tree,tail) do
    {children, tail} = term([], tail)
    subtree = [{:expression, children}]
    {tree ++ subtree, tail}
  end

  def expression_list(tree, tail) do
    subtree = [{:expressionList, []}]
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
end
