defmodule Jack.IfCollapser do
  def collapse(ast) do
    {ast, idx} = collapse(ast, 0)
    ast
  end

  def collapse([{:ifStatement, statement}|tail], idx) do
    {condition, statement} = condition(statement)
    {true_statements, statement} = statements(statement)
    {true_statements, sub_idx} = collapse(true_statements, idx + 1)
    {else_or_empty, _statement} = else_or_empty(statement)
    {else_or_empty, sub_idx} = collapse(else_or_empty, sub_idx)
    map = %{
      index: idx,
      condition: condition,
      true_statements: true_statements,
      false_statements: else_or_empty,
    }
    {tail,sub_idx} = collapse(tail,sub_idx)
    {[{:ifStatement, map}|tail], sub_idx}
  end
  def collapse([],idx), do: {[], idx}
  def collapse([{type,list}|tail],idx) when is_list(list) do
    {list, idx} = collapse(list,idx)
    {tail, idx} = collapse(tail, idx)
    {[{type,list}|tail], idx}
  end
  def collapse([head|tail],idx) do
    {tail, idx} = collapse(tail,idx)
    {[head|tail], idx}
  end

  defp condition([{:keyword,"if"},{:symbol,"("},{:expression,exp},{:symbol,")"}| tail]) do
    {exp, tail}
  end

  defp statements([{:symbol,"{"},{:statements,st},{:symbol,"}"}|tail]) do
    {st, tail}
  end

  defp else_or_empty([{:keyword,"else"}|tail]), do: statements(tail)
  defp else_or_empty([]), do: {[],[]}
end
