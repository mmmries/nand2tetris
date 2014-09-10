defmodule Jack.SymbolTable do
  def generate({:class, ast}) do
    {ast, symbols} = replace(ast, %{})
    {:class, ast}
  end

  defp replace([{:keyword, "class"},{:identifier, id}|rest], symbols) do
    id_map = %{:name => id, :category => "class", :definition => true}
    list = [keyword: "class", identifier: id_map]
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
  defp cvd([{:identifier,id}|tail], syms, temp) do
    id_map = %{ :category => Dict.get(temp, :category), :name => id, :definition => true, :index => Dict.size(syms) + 1 }
    syms = Dict.put(syms, id, id_map)
    {tail, syms} = cvd(tail, syms, temp)
    {[{:identifier, id_map}|tail], syms}
  end
  defp cvd([head|tail], syms, temp) do
    {tail, syms} = cvd(tail, syms, temp)
    {[head|tail], syms}
  end
end
