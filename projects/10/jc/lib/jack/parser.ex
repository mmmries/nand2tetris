defmodule Jack.Parser do
  def parse(tokens) do
    class(tokens)
  end

  def identifier(tree,[{:identifier,id}|tail]), do: {tree++[identifier: id], tail}

  def sym(symbol, tree, [{:symbol, symbol}|tail]), do: {tree++[symbol: symbol],tail}

  def type(tree, [{:keyword, type}|tail])
    when type in ["int","char","boolean"], do: {tree ++ [{:keyword, type}], tail}
  def type(tree, [{:identifier, class}|tail]) do
    {tree ++ [{:identifier, class}], tail}
  end

  defp class([{:keyword, "class"},{:identifier, id},{:symbol, "{"}|tail]) do
    children = [
      {:keyword, "class"},
      {:identifier, id},
      {:symbol, "{"}
    ]
    {children, tail} = class_var_dec(children, tail)
    {children, tail} = sub_dec(children, tail)
    {children, tail} = sym("}", children, tail)
    {:class, children}
  end

  defp class_var_dec(tree, [{:keyword,kw}|tail]) when(kw in ["static","field"]) do
    {children, tail} = type([keyword: kw],tail)
    {children, tail} = identifier_list(children, tail)
    subtree = [classVarDec: children]
    class_var_dec(tree ++ subtree, tail)
  end
  defp class_var_dec(tree, tail), do: {tree, tail}

  defp identifier_list(tree, [{:identifier,name},{:symbol,","}|tail]) do
    identifier_list(tree ++ [{:identifier,name},{:symbol,","}], tail)
  end
  defp identifier_list(tree, [{:identifier,name},{:symbol,";"}|tail]) do
    {tree ++ [{:identifier,name},{:symbol,";"}], tail}
  end

  defp sub_dec(tree, [{:keyword,type}|tail]) when (type in ["constructor","function","method"]) do
    children = [{:keyword, type}]
    {children,tail} = type_or_void(children,tail)
    {children, tail} = identifier(children, tail)
    {children, tail} = Jack.ParamsList.parse(children, tail)
    {children, tail} = sub_body(children, tail)
    subtree = {:subroutineDec, children}
    sub_dec(tree ++ [subtree], tail)
  end
  defp sub_dec(tree, tail), do: {tree, tail}

  defp type_or_void(tree, [{:keyword,"void"}|tail]) do
    {tree ++ [keyword: "void"], tail}
  end
  defp type_or_void(tree, tail), do: type(tree, tail)

  defp sub_body(tree, [{:symbol,"{"}|tail]) do
    {children, tail} = var_decs([symbol: "{"], tail)
    {children, tail} = Jack.Statements.parse(children, tail)
    {children, tail} = sym("}", children, tail)
    subtree = {:subroutineBody, children}
    {tree ++ [subtree], tail}
  end

  defp var_decs(tree, [{:keyword,"var"}|tail]) do
    {children,tail} = type([keyword: "var"],tail)
    {children, tail} = identifier_list(children,tail)
    subtree = [varDec: children]
    var_decs(tree ++ subtree, tail)
  end
  defp var_decs(tree,tail), do: {tree, tail}
end
