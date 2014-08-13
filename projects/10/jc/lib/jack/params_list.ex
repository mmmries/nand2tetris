defmodule Jack.ParamsList do
  def parse(tree, [{:symbol,"("}|tail]) do
    {children, tail} = param([], tail)
    subtree = [symbol: "(", parameterList: children, symbol: ")"]
    {tree ++ subtree, tail}
  end

  defp param(tree, [{:symbol, ")"}|tail]), do: {tree, tail}
  defp param(tree, [{:symbol,","}|tail]) do
    tree = tree++[symbol: ","]
    {tree, tail} = Jack.Parser.type(tree, tail)
    {tree, tail} = Jack.Parser.identifier(tree, tail)
    param(tree, tail)
  end
  defp param(tree, tail) do
    {tree, tail} = Jack.Parser.type(tree, tail)
    {tree, tail} = Jack.Parser.identifier(tree, tail)
    param(tree, tail)
  end
end
