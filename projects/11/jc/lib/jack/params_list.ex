defmodule Jack.ParamsList do
  import Jack.Parser, only: [sym: 3]

  def parse(tree, [{:symbol,"("}|tail]) do
    {children, tail} = param([], tail)
    subtree = [symbol: "(", parameterList: children]
    {subtree, tail} = sym(")", subtree, tail)
    {tree ++ subtree, tail}
  end

  defp param(tree, [{:symbol, ")"}|_]=tail), do: {tree, tail}
  defp param(tree, [{:symbol,","}|tail]) do
    {tree, tail} = Jack.Parser.type(tree ++ [symbol: ","], tail)
    {tree, tail} = Jack.Parser.identifier(tree, tail)
    param(tree, tail)
  end
  defp param(tree, tail) do
    {tree, tail} = Jack.Parser.type(tree, tail)
    {tree, tail} = Jack.Parser.identifier(tree, tail)
    param(tree, tail)
  end
end
