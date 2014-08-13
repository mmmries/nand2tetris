defmodule Jack.Parser do
  def parse(tokens) do
    class(tokens)
  end

  def identifier(tree,[{:identifier,id}|tail]), do: {tree++[identifier: id], tail}

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
    [{:symbol, "}"}|tail] = tail
    children = children ++ [{:symbol,"}"}]
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

  defp sub_dec(tree, [{:keyword, type}|tail]) when(type in ["constructor","function","method"]) do
    children = [{:keyword, type}]
    {children,tail} = type_or_void(children,tail)
    [{:identifier,fn_name}|tail] = tail
    children = children ++ [{:identifier,fn_name}]
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
    children = [{:symbol,"{"}]
    {children, tail} = var_decs(children, tail)
    {children, tail} = statements(children, tail)
    [{:symbol,"}"}|tail] = tail
    children = children ++ [{:symbol,"}"}]
    subtree = {:subroutineBody, children}
    {tree ++ [subtree], tail}
  end

  defp var_decs(tree, [{:keyword,"var"}|tail]) do
    children = [{:keyword, "var"}]
    {children, tail} = var_dec(children, tail)
    var_decs(tree ++ [{:varDec,children}], tail)
  end
  defp var_decs(tree,tail), do: {tree, tail}

  defp var_dec(tree, [{:symbol,";"}|tail]), do: {tree ++ [{:symbol,";"}], tail}
  defp var_dec(tree, tail) do
    {children, tail} = type(tree,tail)
    [{:identifier, name}|tail] = tail
    var_dec(children ++ [{:identifier, name}], tail)
  end

  defp statements(tree, tail) do
    {children, tail} = statement([], tail)
    {children, tail} = statement(children, tail)
    {children, tail} = statement(children, tail)
    {children, tail} = statement(children, tail)
    subtree = [{:statements, children}]
    {tree ++ subtree, tail}
  end

  defp statement(tree, [{:keyword,"let"},{:identifier,name},{:symbol,"="}|tail]) do
    children = [{:keyword,"let"},{:identifier,name},{:symbol,"="}]
    {children, tail} = expression(children, tail)
    [{:symbol,";"}|tail] = tail
    children = children ++ [{:symbol,";"}]
    subtree = [{:letStatement, children}]
    {tree ++ subtree, tail}
  end
  defp statement(tree, [{:keyword,"do"}|tail]) do
    {children, tail} = sub_call([{:keyword,"do"}], tail)
    [{:symbol,";"}|tail] = tail
    children = children ++ [{:symbol,";"}]
    subtree = [{:doStatement, children}]
    {tree ++ subtree, tail}
  end
  defp statement(tree, [{:keyword,"return"},{:symbol,";"}|tail]) do
    children = [{:keyword,"return"},{:symbol,";"}]
    subtree = [{:returnStatement, children}]
    {tree ++ subtree, tail}
  end
  defp statement(tree, [{:keyword,"return"}|tail]) do
    {children, tail} = expression([keyword: "return"], tail)
    [{:symbol,";"}|tail] = tail
    children = children ++ [symbol: ";"]
    subtree = [returnStatement: children]
    {tree ++ subtree, tail}
  end
  defp statement(tree,tail), do: {tree, tail}

  defp expression(tree,tail) do
    {children, tail} = term([], tail)
    subtree = [{:expression, children}]
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

  defp sub_call(tree, [{:identifier,target},{:symbol,"."},{:identifier,method},{:symbol,"("}|tail]) do
    children = [{:identifier,target},{:symbol,"."},{:identifier,method},{:symbol,"("}]
    {children, tail} = expression_list(children,tail)
    [{:symbol, ")"}|tail] = tail
    children = children ++ [{:symbol,")"}]
    {tree ++ children, tail}
  end

  defp expression_list(tree, tail) do
    subtree = [{:expressionList, []}]
    {tree ++ subtree, tail}
  end
end
