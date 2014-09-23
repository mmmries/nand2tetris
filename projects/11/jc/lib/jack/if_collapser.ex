defmodule Jack.IfCollapser do
  def collapse(ast), do: collapse(ast,0)

  def collapse([{:ifStatement, statement}|tail], idx) do
    {condition, statement} = condition(statement)
    {true_statements, statement} = statements(statement)
    {else_or_empty, _statement} = else_or_empty(statement)
    map = %{
      index: idx,
      condition: condition,
      true_statements: true_statements,
      false_statements: else_or_empty,
    }
    [{:ifStatement, map}|collapse(tail,idx+1)]
  end
  def collapse([],_idx), do: []
  def collapse([{type,list}|tail],idx) when is_list(list) do
    list = collapse(list,idx)
    [{type,list}|collapse(tail,idx)]
  end
  def collapse([head|tail],idx), do: [head|collapse(tail,idx)]

  defp condition([{:keyword,"if"},{:symbol,"("},{:expression,exp},{:symbol,")"}| tail]) do
    {exp, tail}
  end

  defp statements([{:symbol,"{"},{:statements,st},{:symbol,"}"}|tail]) do
    {st, tail}
  end

  defp else_or_empty([{:keyword,"else"}|tail]), do: statements(tail)
  defp else_or_empty([]), do: {[],[]}
end
