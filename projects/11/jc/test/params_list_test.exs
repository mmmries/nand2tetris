defmodule Jack.ParamsListTest do
  use ExUnit.Case
  import Jack.Tokenizer, only: [tokenize: 1]
  import Jack.ParamsList, only: [parse: 2]

  test "parses an empty parameter list" do
    jack = "()"
    expected = [symbol: "(", parameterList: [], symbol: ")"]

    tail = jack |> tokenize
    assert parse([], tail) == {expected, []}
  end

  test "parses a parameter list with one parameter" do
    jack = "( int x )"
    expected = [
      symbol: "(",
      parameterList: [
        keyword: "int",
        identifier: "x"
      ],
      symbol: ")"]

    tail = jack |> tokenize
    assert parse([], tail) == {expected, []}
  end

  test "parses a parameter list with multiple parameters" do
    jack = "( int x, Jack j, int y )"
    expected = [
      symbol: "(",
      parameterList: [
        keyword: "int",
        identifier: "x",
        symbol: ",",
        identifier: "Jack",
        identifier: "j",
        symbol: ",",
        keyword: "int",
        identifier: "y",
      ],
      symbol: ")"]

    tail = jack |> tokenize
    assert parse([], tail) == {expected, []}
  end
end
