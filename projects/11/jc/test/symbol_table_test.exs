defmodule SymbolTableTest do
  use ExUnit.Case
  import Jack.Tokenizer, only: [tokenize: 1]
  import Jack.Parser, only: [parse: 1]
  import Jack.SymbolTable, only: [generate: 1]

  test "simple case" do
    jack = """
      class Simple {
        field int x, y;
        static int debug;
      }
    """

    expected = {:class, [
      keyword: "class",
      identifier: %{
        :name =>"Simple",
        :category => "class",
        :definition => true},
      symbol: "{",
      classVarDec: [
        keyword: "field",
        keyword: "int",
        identifier: %{
          :name => "x",
          :category => "field",
          :index => 1,
          :definition => true},
        symbol: ",",
        identifier: %{
          :name => "y",
          :category => "field",
          :index => 2,
          :definition => true},
        symbol: ";"
      ],
      classVarDec: [
        keyword: "static",
        keyword: "int",
        identifier: %{
          :name => "debug",
          :category => "static",
          :index => 1,
          :definition => true },
        symbol: ";"
      ],
      symbol: "}"
    ]}

    assert jack |> tokenize |> parse |> generate == expected
  end
end
