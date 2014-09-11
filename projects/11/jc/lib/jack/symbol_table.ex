defmodule Jack.SymbolTable do
  def generate({:class, ast}) do
    {ast, _symbols} = replace(ast, %{"class" => nil, "field" => %{}, "static" => %{}, "argument" => %{}, "var" => %{}})
    {:class, ast}
  end

  defp replace([{:keyword, "class"},{:identifier, id}|rest], symbols) do
    id_map = %{:name => id, :category => "class", :definition => true}
    list = [keyword: "class", identifier: id_map]
    symbols = Dict.put(symbols, "class", id)
    {rest, symbols} = replace(rest, symbols)
    {list ++ rest, symbols}
  end
  defp replace([{:classVarDec,dec}|rest], syms) do
    {dec, syms} = cvd(dec,syms,%{})
    {rest,syms} = replace(rest, syms)
    {[{:classVarDec,dec}|rest],syms}
  end
  defp replace([{:subroutineDec,dec}|rest], syms) do
    {dec, _sub_syms} = sub(dec,syms)
    {rest,syms} = replace(rest, syms)
    {[{:subroutineDec,dec}|rest],syms}
  end
  defp replace([],symbols) do
    {[], symbols}
  end
  defp replace([head|tail], symbols) do
    {tail, symbols} = replace(tail, symbols)
    {[head|tail], symbols}
  end

  defp cvd([], syms, _temp), do: {[], syms}
  defp cvd([{:keyword, kw},type|tail], syms, temp) when (kw in ["field","static"]) do
    temp = Dict.put_new(temp, :category, kw)
    {tail, syms} = cvd(tail, syms, temp)
    {[{:keyword, kw},type|tail],syms}
  end
  defp cvd([{:identifier,id}|tail], syms, %{:category => c}=temp) do
    idx = (syms |> Dict.get(c) |> Dict.size) + 1
    id_map = %{ :category => c, :name => id, :definition => true, :index => idx }
    syms = Dict.update!(syms, c, &(Dict.put_new(&1,id,id_map)))
    {tail, syms} = cvd(tail, syms, temp)
    {[{:identifier, id_map}|tail], syms}
  end
  defp cvd([head|tail], syms, temp) do
    {tail, syms} = cvd(tail, syms, temp)
    {[head|tail], syms}
  end

  defp sub([], syms), do: {[], syms}
  defp sub([{:keyword,kw},type,{:identifier,id}|tail], syms) when (kw in ["function","method"]) do
    id_map = %{:name => id, :category => "subroutine", :definition => true}
    {tail,syms} = sub(tail, syms)
    {[{:keyword,kw},type,{:identifier, id_map}|tail], syms}
  end
  defp sub([{:parameterList,params}|tail], syms) do
    {params, syms} = params(params,syms)
    {tail,syms} = sub(tail, syms)
    {[{:parameterList,params}|tail], syms}
  end
  defp sub([{:subroutineBody,body}|tail], syms) do
    {body, syms} = body(body,syms)
    {tail,syms} = sub(tail,syms)
    {[{:subroutineBody,body}|tail], syms}
  end
  defp sub([head|tail], syms) do
    {tail, syms} = sub(tail, syms)
    {[head|tail], syms}
  end

  defp params([],syms), do: {[],syms}
  defp params([{:keyword, "var"}|tail],syms) do
    {tail, syms} = params(tail, syms)
    {[{:keyword,"var"}|tail], syms}
  end
  defp params([type,{:identifier, id}|tail],syms) do
    idx = (syms |> Dict.get("argument") |> Dict.size) + 1
    id_map = %{:name => id, :category => "argument", :index => idx, :definition => true}
    syms = Dict.update!(syms, "argument", &(Dict.put_new(&1,id,id_map)))
    {tail, syms} = params(tail, syms)
    {[type,{:identifier,id_map}|tail], syms}
  end
  defp params([head|tail], syms) do
    {tail, syms} = params(tail, syms)
    {[head|tail], syms}
  end

  defp body([],syms), do: {[],syms}
  defp body([{:varDec,dec}|tail], syms) do
    {dec, syms} = vd(dec, syms)
    {tail, syms} = body(tail, syms)
    {[{:varDec,dec}|tail],syms}
  end
  defp body([head|tail], syms) do
    {tail,syms} = body(tail, syms)
    {[head|tail], syms}
  end

  defp vd([], syms), do: {[], syms}
  defp vd([{:keyword, "var"},type|tail], syms) do
    {tail, syms} = vd(tail, syms)
    {[{:keyword, "var"},type|tail],syms}
  end
  defp vd([{:identifier,id}|tail], syms) do
    idx = (syms |> Dict.get("var") |> Dict.size) + 1
    id_map = %{ :category => "var", :name => id, :definition => true, :index => idx }
    syms = Dict.update!(syms, "var", &(Dict.put_new(&1,id,id_map)))
    {tail, syms} = vd(tail, syms)
    {[{:identifier, id_map}|tail], syms}
  end
  defp vd([head|tail], syms) do
    {tail, syms} = vd(tail, syms)
    {[head|tail], syms}
  end
end
