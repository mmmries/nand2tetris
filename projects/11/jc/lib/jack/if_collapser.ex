defmodule Jack.IfCollapser do
  def collapse([{:ifStatement, statement}|tail]) do
    {condition, statement} = condition(statement)
    {true_statements, statement} = statements(statement)
    {else_or_empty, _statement} = else_or_empty(statement)
    map = %{
      condition: condition,
      true_statements: true_statements,
      false_statements: else_or_empty,
    }
    [{:ifStatement, map}|collapse(tail)]
  end
  def collapse([]), do: []
  def collapse([{type,list}|tail]) when is_list(list) do
    list = collapse(list)
    [{type,list}|collapse(tail)]
  end
  def collapse([head|tail]), do: [head|collapse(tail)]

  defp condition([{:keyword,"if"},{:symbol,"("},{:expression,exp},{:symbol,")"}| tail]) do
    {exp, tail}
  end

  defp statements([{:symbol,"{"},{:statements,st},{:symbol,"}"}|tail]) do
    {st, tail}
  end

  defp else_or_empty([{:keyword,"else"}|tail]), do: statements(tail)
  defp else_or_empty([]), do: {[],[]}
end
