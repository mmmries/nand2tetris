defmodule SymbolTableTest do
  use ExUnit.Case
  import Jack.Tokenizer, only: [tokenize: 1]
  import Jack.Parser, only: [parse: 1]
  import Jack.SymbolTable, only: [generate: 1]

  test "class fields and statics" do
    jack = """
      class Simple {
        field int x, y;
        static String debug;
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
        identifier: "String",
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

  test "argument and var declarations" do
    jack = """
      class Simple {
        function void main(int argc, int argv){
          var String s;
          var int x, y;
        }
      }
    """

    expected = {:class, [
      keyword: "class",
      identifier: %{ :name => "Simple", :category => "class", :definition => true },
      symbol: "{",
      subroutineDec: [
        keyword: "function",
        keyword: "void",
        identifier: %{ :name => "main", :category => "subroutine", :definition => true},
        symbol: "(",
        parameterList: [
          keyword: "int",
          identifier: %{:name => "argc", :category => "argument", :definition => true, :index => 1},
          symbol: ",",
          keyword: "int",
          identifier: %{:name => "argv", :category => "argument", :definition => true, :index => 2} ],
        symbol: ")",
        subroutineBody: [
          symbol: "{",
          varDec: [
            keyword: "var",
            identifier: "String",
            identifier: %{:name => "s", :category => "var", :definition => true, :index => 1},
            symbol: ";" ],
          varDec: [
            keyword: "var",
            keyword: "int",
            identifier: %{:name => "x", :category => "var", :definition => true, :index => 2},
            symbol: ",",
            identifier: %{:name => "y", :category => "var", :definition => true, :index => 3},
            symbol: ";"],
          statements: [],
          symbol: "}" ]
      ],
      symbol: "}"
    ]}

    assert jack |> tokenize |> parse |> generate == expected
  end

  test "usage of fields, arguments and locals" do
    jack = """
      class Simple {
        field int x, y;
        function void main(int argc){
          var int z;
          let z = x + y + argc;
        }
      }
    """

    expected = {:class, [
      keyword: "class",
      identifier: %{ :name => "Simple", :category => "class", :definition => true },
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
      subroutineDec: [
        keyword: "function",
        keyword: "void",
        identifier: %{ :name => "main", :category => "subroutine", :definition => true},
        symbol: "(",
        parameterList: [
          keyword: "int",
          identifier: %{:name => "argc", :category => "argument", :definition => true, :index => 1} ],
        symbol: ")",
        subroutineBody: [
          symbol: "{",
          varDec: [
            keyword: "var",
            keyword: "int",
            identifier: %{:name => "z", :category => "var", :definition => true, :index => 1},
            symbol: ";"
          ],
          statements: [
            letStatement: [
              keyword: "let",
              identifier: %{:name => "z", :category => "var", :definition => false, :index => 1},
              symbol: "=",
              expression: [
                term: [identifier: %{:name => "x", :category => "field", :definition => false, :index => 1}],
                symbol: "+",
                term: [identifier: %{:name => "y", :category => "field", :definition => false, :index => 2}],
                symbol: "+",
                term: [identifier: %{:name => "argc", :category => "argument", :definition => false, :index => 1}]
              ],
              symbol: ";"]
          ],
          symbol: "}" ]
      ],
      symbol: "}"
    ]}

    assert jack |> tokenize |> parse |> generate == expected
  end

  test "it fails on undefined identifiers" do
    jack = """
      class Simple{
        function void main(){
          let x = 4;
        }
      }
    """

    assert_raise ArgumentError, fn ->
      jack |> tokenize |> parse |> generate
    end
  end
end
