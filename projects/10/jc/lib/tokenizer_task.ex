defmodule Mix.Tasks.Tokenizer do
  use Mix.Task
  import JackCompiler, only: [tokenize: 1]

  @shortdoc "tokenize some jack code"

  def run(argv) do
    argv |>
      Enum.map(&File.read!/1) |>
      Enum.join("\n") |>
      tokenize |>
      to_xml |>
      IO.puts
  end

  def to_xml(tokens) do
    tokens_as_xml_string = tokens |> Enum.map(&token_to_xml/1) |> Enum.join("\n")
    "<tokens>\n" <> tokens_as_xml_string <> "\n</tokens>"
  end

  def token_to_xml({type, value}) do
    type_str = to_string(type)
    "<"<>type_str<>">"<>escape(value)<>"</"<>type_str<>">"
  end

  def escape("&"), do: "&amp;"
  def escape("<"), do: "&lt;"
  def escape(">"), do: "&gt;"
  def escape(str), do: str
end
