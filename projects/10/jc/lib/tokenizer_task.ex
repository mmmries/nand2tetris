defmodule Mix.Tasks.Tokenizer do
  use Mix.Task
  import JackCompiler, only: [tokenize: 1]

  @shortdoc "tokenize some jack code"

  def run(argv) do
    jack_code = argv |> Enum.map(&File.read!/1) |> Enum.join("\n")
    xml_els = tokenize(jack_code) |> Enum.map(&token_to_xml_element/1)
    IO.puts XmlBuilder.generate({:tokens, nil, xml_els})
  end

  def token_to_xml_element({type, val}), do: {type, nil, val}
end
