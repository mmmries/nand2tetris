defmodule Jack.ExpressionsTest do
  use ExUnit.Case
  import Jack.Expressions, only: [expression: 2, parse: 2]
  import Jack.Tokenizer, only: [tokenize: 1]

  test "empty expression list" do
    jack = "()"
    expected = [
      symbol: "(",
      expressionList: [],
      symbol: ")" ]

    tokens = tokenize(jack)
    assert parse([], tokens) == {expected, []}
  end

  test "expression list with one expression" do
    jack = "(x)"
    expected = [
      symbol: "(",
      expressionList: [
        expression: [term: [identifier: "x"]]
      ],
      symbol: ")" ]

    tokens = tokenize(jack)
    assert parse([], tokens) == {expected, []}
  end

  test "multiple expressions in a list" do
    jack = "(x, y, 1)"
    expected = [
      symbol: "(",
      expressionList: [
        expression: [term: [identifier: "x"]],
        symbol: ",",
        expression: [term: [identifier: "y"]],
        symbol: ",",
        expression: [term: [integerConstant: "1"]],
      ],
      symbol: ")" ]

    tokens = tokenize(jack)
    assert parse([], tokens) == {expected, []}
  end
end
