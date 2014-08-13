defmodule Jack.StatementsTest do
  use ExUnit.Case
  import Jack.Statements, only: [parse: 2, statement: 2]
  import Jack.Tokenizer, only: [tokenize: 1]

  test "a let statement" do
    jack = "let x = y;"
    expected = [
      statements: [
        letStatement: [
          keyword: "let",
          identifier: "x",
          symbol: "=",
          expression: [term: [identifier: "y"]],
          symbol: ";"]]]

    tokens = tokenize(jack)
    assert parse([],tokens) == {expected, []}
  end

  test "multiple statements" do
    jack = "let x = y; do jack.play();"
    expected = [
      statements: [
        letStatement: [
          keyword: "let",
          identifier: "x",
          symbol: "=",
          expression: [term: [identifier: "y"]],
          symbol: ";"],
        doStatement: [
          keyword: "do",
          identifier: "jack",
          symbol: ".",
          identifier: "play",
          symbol: "(",
          expressionList: [],
          symbol: ")",
          symbol: ";"]]]

    tokens = tokenize(jack)
    assert parse([],tokens) == {expected, []}
  end
end
