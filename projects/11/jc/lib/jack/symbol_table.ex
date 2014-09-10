defmodule Jack.SymbolTable do
  def generate({:class, ast}) do
    {ast, symbols} = replace(ast, %{"class" => nil, "field" => [], "static" => []})
    {:class, ast}
  end

  defp replace([{:keyword, "class"},{:identifier, id}|rest], symbols) do
    id_map = %{:name => id, :category => "class", :definition => true}
    list = [keyword: "class", identifier: id_map]
    symbols = Dict.put(symbols, :class, id)
    {rest, symbols} = replace(rest, symbols)
    {list ++ rest, symbols}
  end
  defp replace([{:classVarDec,dec}|rest], syms) do
    {dec, syms} = cvd(dec,syms,%{})
    {rest,syms} = replace(rest, syms)
    {[{:classVarDec,dec}|rest],syms}
  end
  defp replace([],symbols) do
    {[], symbols}
  end
  defp replace([head|tail], symbols) do
    {tail, symbols} = replace(tail, symbols)
    {[head|tail], symbols}
  end

  defp cvd([], syms, _temp), do: {[], syms}
  defp cvd([{:keyword, kw}|tail], syms, temp) when (kw in ["field","static"]) do
    temp = Dict.put(temp, :category, kw)
    {tail, syms} = cvd(tail, syms, temp)
    {[{:keyword, kw}|tail],syms}
  end
  defp cvd([{:identifier,id}|tail], syms, %{:category => c}=temp) do
    idx = (syms |> Dict.get(c) |> Enum.count) + 1
    id_map = %{ :category => c, :name => id, :definition => true, :index => idx }
    syms = Dict.update!(syms, c, &([id_map|&1]))
    {tail, syms} = cvd(tail, syms, temp)
    {[{:identifier, id_map}|tail], syms}
  end
  defp cvd([head|tail], syms, temp) do
    {tail, syms} = cvd(tail, syms, temp)
    {[head|tail], syms}
  end
end
