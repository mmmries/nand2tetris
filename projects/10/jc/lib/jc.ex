defmodule JackCompiler do
  def tokenize(jack_str) do
    tokenize(jack_str, [])
  end

  defp tokenize(" "<>jack_str, tokens), do: tokenize(jack_str, tokens)
  defp tokenize("\n"<>jack_str, tokens), do: tokenize(jack_str, tokens)
  defp tokenize("class"<>jack_str, tokens), do: tokenize(jack_str, [{:keyword, "class"}|tokens])
  defp tokenize("constructor"<>jack_str, tokens), do: tokenize(jack_str, [{:keyword, "constructor"}|tokens])
  defp tokenize("function"<>jack_str, tokens), do: tokenize(jack_str, [{:keyword, "function"}|tokens])
  defp tokenize("method"<>jack_str, tokens), do: tokenize(jack_str, [{:keyword, "method"}|tokens])
  defp tokenize("field"<>jack_str, tokens), do: tokenize(jack_str, [{:keyword, "field"}|tokens])
  defp tokenize("static"<>jack_str, tokens), do: tokenize(jack_str, [{:keyword, "static"}|tokens])
  defp tokenize("var"<>jack_str, tokens), do: tokenize(jack_str, [{:keyword, "var"}|tokens])
  defp tokenize("int"<>jack_str, tokens), do: tokenize(jack_str, [{:keyword, "int"}|tokens])
  defp tokenize("char"<>jack_str, tokens), do: tokenize(jack_str, [{:keyword, "char"}|tokens])
  defp tokenize("boolean"<>jack_str, tokens), do: tokenize(jack_str, [{:keyword, "boolean"}|tokens])
  defp tokenize("void"<>jack_str, tokens), do: tokenize(jack_str, [{:keyword, "void"}|tokens])
  defp tokenize("true"<>jack_str, tokens), do: tokenize(jack_str, [{:keyword, "true"}|tokens])
  defp tokenize("false"<>jack_str, tokens), do: tokenize(jack_str, [{:keyword, "false"}|tokens])
  defp tokenize("null"<>jack_str, tokens), do: tokenize(jack_str, [{:keyword, "null"}|tokens])
  defp tokenize("this"<>jack_str, tokens), do: tokenize(jack_str, [{:keyword, "this"}|tokens])
  defp tokenize("let"<>jack_str, tokens), do: tokenize(jack_str, [{:keyword, "let"}|tokens])
  defp tokenize("do"<>jack_str, tokens), do: tokenize(jack_str, [{:keyword, "do"}|tokens])
  defp tokenize("if"<>jack_str, tokens), do: tokenize(jack_str, [{:keyword, "if"}|tokens])
  defp tokenize("else"<>jack_str, tokens), do: tokenize(jack_str, [{:keyword, "else"}|tokens])
  defp tokenize("while"<>jack_str, tokens), do: tokenize(jack_str, [{:keyword, "while"}|tokens])
  defp tokenize("return"<>jack_str, tokens), do: tokenize(jack_str, [{:keyword, "return"}|tokens])
  defp tokenize("("<>jack_str, tokens), do: tokenize(jack_str, [{:symbol, "("}|tokens])
  defp tokenize(")"<>jack_str, tokens), do: tokenize(jack_str, [{:symbol, ")"}|tokens])
  defp tokenize("["<>jack_str, tokens), do: tokenize(jack_str, [{:symbol, "["}|tokens])
  defp tokenize("]"<>jack_str, tokens), do: tokenize(jack_str, [{:symbol, "]"}|tokens])
  defp tokenize("{"<>jack_str, tokens), do: tokenize(jack_str, [{:symbol, "{"}|tokens])
  defp tokenize("}"<>jack_str, tokens), do: tokenize(jack_str, [{:symbol, "}"}|tokens])
  defp tokenize("<"<>jack_str, tokens), do: tokenize(jack_str, [{:symbol, "<"}|tokens])
  defp tokenize(">"<>jack_str, tokens), do: tokenize(jack_str, [{:symbol, ">"}|tokens])
  defp tokenize("."<>jack_str, tokens), do: tokenize(jack_str, [{:symbol, "."}|tokens])
  defp tokenize(","<>jack_str, tokens), do: tokenize(jack_str, [{:symbol, ","}|tokens])
  defp tokenize(";"<>jack_str, tokens), do: tokenize(jack_str, [{:symbol, ";"}|tokens])
  defp tokenize("+"<>jack_str, tokens), do: tokenize(jack_str, [{:symbol, "+"}|tokens])
  defp tokenize("-"<>jack_str, tokens), do: tokenize(jack_str, [{:symbol, "-"}|tokens])
  defp tokenize("*"<>jack_str, tokens), do: tokenize(jack_str, [{:symbol, "*"}|tokens])
  defp tokenize("/"<>jack_str, tokens), do: tokenize(jack_str, [{:symbol, "/"}|tokens])
  defp tokenize("&"<>jack_str, tokens), do: tokenize(jack_str, [{:symbol, "&"}|tokens])
  defp tokenize("|"<>jack_str, tokens), do: tokenize(jack_str, [{:symbol, "|"}|tokens])
  defp tokenize("~"<>jack_str, tokens), do: tokenize(jack_str, [{:symbol, "~"}|tokens])
  defp tokenize("="<>jack_str, tokens), do: tokenize(jack_str, [{:symbol, "="}|tokens])
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
            end
        end
    end
  end
end
