defmodule Mix.Tasks.Parse do
  use Mix.Task

  @shortdoc "tokenize and parse some jack code"

  def run(argv) do
    argv |>
      Enum.map(&File.read!/1) |>
      Enum.join("\n") |>
      Jack.Tokenizer.tokenize |>
      Jack.Parser.parse |>
      token_to_xml |>
      IO.write
  end

  defp to_xml(tokens) do
    tokens |> Enum.map(&token_to_xml/1) |> Enum.join("")
  end

  def token_to_xml({type, list}) when is_list(list) do
    "<#{type}>\n" <> to_xml(list) <> "</#{type}>\n"
  end
  def token_to_xml({type, value}) do
    "<#{type}>"<>escape(value)<>"</#{type}>\n"
  end

  defp escape("&"), do: "&amp;"
  defp escape("<"), do: "&lt;"
  defp escape(">"), do: "&gt;"
  defp escape(str), do: str
end
