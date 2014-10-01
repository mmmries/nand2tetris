defmodule SymbolTableTest do
  use ExUnit.Case
  import Jack.Tokenizer, only: [tokenize: 1]
  import Jack.Parser, only: [parse: 1]
  import Jack.SymbolTable, only: [resolve: 1]

  test "class fields and statics" do
    jack = """
      class Simple {
        field int x, y;
        static String debug;
      }
    """

    expected = [
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
          :index => 0,
          :definition => true,
          :type => "int"},
        symbol: ",",
        identifier: %{
          :name => "y",
          :category => "field",
          :index => 1,
          :definition => true,
          :type => "int"},
        symbol: ";"
      ],
      classVarDec: [
        keyword: "static",
        identifier: "String",
        identifier: %{
          :name => "debug",
          :category => "static",
          :index => 0,
          :definition => true,
          :type => "String"},
        symbol: ";"
      ],
      symbol: "}"
    ]

    assert jack |> tokenize |> parse |> resolve == expected
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

    expected = [
      keyword: "class",
      identifier: %{ :name => "Simple", :category => "class", :definition => true },
      symbol: "{",
      subroutineDec: [
        keyword: "function",
        keyword: "void",
        identifier: %{ :name => "main", :category => "subroutine", :definition => true, :class => "Simple", :local_vars => 3},
        symbol: "(",
        parameterList: [
          keyword: "int",
          identifier: %{:name => "argc", :category => "argument", :definition => true, :index => 0, :type => "int"},
          symbol: ",",
          keyword: "int",
          identifier: %{:name => "argv", :category => "argument", :definition => true, :index => 1, :type => "int"} ],
        symbol: ")",
        subroutineBody: [
          symbol: "{",
          varDec: [
            keyword: "var",
            identifier: "String",
            identifier: %{:name => "s", :category => "var", :definition => true, :index => 0, :type => "String"},
            symbol: ";" ],
          varDec: [
            keyword: "var",
            keyword: "int",
            identifier: %{:name => "x", :category => "var", :definition => true, :index => 1, :type => "int"},
            symbol: ",",
            identifier: %{:name => "y", :category => "var", :definition => true, :index => 2, :type => "int"},
            symbol: ";"],
          statements: [],
          symbol: "}" ]
      ],
      symbol: "}"
    ]

    assert jack |> tokenize |> parse |> resolve == expected
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

    expected = [
      keyword: "class",
      identifier: %{ :name => "Simple", :category => "class", :definition => true },
      symbol: "{",
      classVarDec: [
        keyword: "field",
        keyword: "int",
        identifier: %{
          :name => "x",
          :category => "field",
          :index => 0,
          :definition => true,
          :type => "int"},
        symbol: ",",
        identifier: %{
          :name => "y",
          :category => "field",
          :index => 1,
          :definition => true,
          :type => "int"},
        symbol: ";"
      ],
      subroutineDec: [
        keyword: "function",
        keyword: "void",
        identifier: %{ :name => "main", :category => "subroutine", :definition => true, :class => "Simple", :local_vars => 1},
        symbol: "(",
        parameterList: [
          keyword: "int",
          identifier: %{:name => "argc", :category => "argument", :definition => true, :index => 0, :type => "int"} ],
        symbol: ")",
        subroutineBody: [
          symbol: "{",
          varDec: [
            keyword: "var",
            keyword: "int",
            identifier: %{:name => "z", :category => "var", :definition => true, :index => 0, :type => "int"},
            symbol: ";"
          ],
          statements: [
            letStatement: [
              keyword: "let",
              identifier: %{:name => "z", :category => "var", :definition => false, :index => 0, :type => "int"},
              symbol: "=",
              expression: [
                term: [identifier: %{:name => "x", :category => "field", :definition => false, :index => 0, :type => "int"}],
                symbol: "+",
                term: [identifier: %{:name => "y", :category => "field", :definition => false, :index => 1, :type => "int"}],
                symbol: "+",
                term: [identifier: %{:name => "argc", :category => "argument", :definition => false, :index => 0, :type => "int"}]
              ],
              symbol: ";"]
          ],
          symbol: "}" ]
      ],
      symbol: "}"
    ]

    assert jack |> tokenize |> parse |> resolve == expected
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
      jack |> tokenize |> parse |> resolve
    end
  end

  test "can call functions with implicit receiver" do
    jack = """
      class Simple{
        function void main(){
          do draw();
        }
      }
    """

    ast = jack |> tokenize |> parse |> resolve
    id = first_by_type(ast, :subroutineDec) |>
      first_by_type(:subroutineBody) |>
      first_by_type(:statements) |>
      first_by_type(:doStatement) |>
      first_by_type(:identifier)
    assert id == %{:name => "draw", :class => "Simple", :category => "subroutine", :definition => false, :numArgs => 1, :receiver => :this}
  end

  test "can call functions with explicit receiver" do
    jack = """
      class Simple{
        function void main(String x){
          do Memory.deAlloc(this, 2);
          do x.challenge();
        }
      }
    """

    ast = jack |> tokenize |> parse |> resolve
    statements = first_by_type(ast, :subroutineDec) |>
      first_by_type(:subroutineBody) |>
      first_by_type(:statements)
    method = statements |>
      first_by_type(:doStatement) |>
      first_by_type(:identifier)
    assert method == %{:name => "deAlloc", :class => "Memory", :category => "subroutine", :definition => false, :numArgs => 2}

    method = statements |>
      last_by_type(:doStatement) |>
      first_by_type(:identifier)
    assert method == %{:name => "challenge", :class => "String", :receiver => %{definition: false, index: 0, category: "argument", name: "x", type: "String"}, :category => "subroutine", :definition => false, :numArgs => 1}
  end

  def by_type(ast, type) do
    selector = fn (t) -> fn ({type,_val}) -> type == t end end
    ast |> Enum.filter(selector.(type))
  end

  def first_by_type(ast, type) do
    {_type, sub} = by_type(ast, type) |> List.first
    sub
  end

  def last_by_type(ast, type) do
    {_type, sub} = by_type(ast, type) |> List.last
    sub
  end
end
