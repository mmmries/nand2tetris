defmodule JackCompiler do
  def tokenize(jack_str) do
    tokenize(jack_str, [])
  end

  defp tokenize(" "<>jack_str, tokens), do: tokenize(jack_str, tokens)
  defp tokenize("\n"<>jack_str, tokens), do: tokenize(jack_str, tokens)
  defp tokenize("if"<>jack_str, tokens), do: tokenize(jack_str, [{:keyword, "if"}|tokens])
  defp tokenize("let"<>jack_str, tokens), do: tokenize(jack_str, [{:keyword, "let"}|tokens])
  defp tokenize("("<>jack_str, tokens), do: tokenize(jack_str, [{:symbol, "("}|tokens])
  defp tokenize(")"<>jack_str, tokens), do: tokenize(jack_str, [{:symbol, ")"}|tokens])
  defp tokenize("{"<>jack_str, tokens), do: tokenize(jack_str, [{:symbol, "{"}|tokens])
  defp tokenize("}"<>jack_str, tokens), do: tokenize(jack_str, [{:symbol, "}"}|tokens])
  defp tokenize(">"<>jack_str, tokens), do: tokenize(jack_str, [{:symbol, ">"}|tokens])
  defp tokenize("<"<>jack_str, tokens), do: tokenize(jack_str, [{:symbol, "<"}|tokens])
  defp tokenize("="<>jack_str, tokens), do: tokenize(jack_str, [{:symbol, "="}|tokens])
  defp tokenize(";"<>jack_str, tokens), do: tokenize(jack_str, [{:symbol, ";"}|tokens])
  defp tokenize("", tokens), do: Enum.reverse(tokens)
  defp tokenize(jack_str, tokens) do
    case Regex.named_captures(~r/\A(?<id>[a-zA-Z_][a-zA-Z_\d]*)(?<rest>.*)/s, jack_str) do
      %{"id" => id, "rest" => rest} ->
        tokenize(rest, [{:identifier, id}|tokens])
      nil ->
        case Regex.named_captures(~r/\A(?<num>\d+)(?<rest>.*)/s, jack_str) do
          %{"num" => num, "rest" => rest} ->
            tokenize(rest, [{:integerConstant, num}|tokens])
          nil ->
            case Regex.named_captures(~r/\A"(?<s>[^"\n]*)"(?<rest>.*)/s, jack_str) do
              %{"s" => s, "rest" => rest} ->
                tokenize(rest, [{:stringConstant,s}|tokens])
              nil ->
                tokenize("", tokens)
            end
        end
    end
  end
end
