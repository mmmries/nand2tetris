defmodule Jack.StatementsTest do
  use ExUnit.Case
  import Jack.Statements, only: [parse: 2, statement: 2]
  import Jack.Tokenizer, only: [tokenize: 1]

  test "a do statement with explicit receiver" do
    jack = "do test.go();"
    expected = [
      doStatement: [
        keyword: "do",
        identifier: "test",
        symbol: ".",
        identifier: "go",
        symbol: "(",
        expressionList: [],
        symbol: ")",
        symbol: ";"]]

    tokens = tokenize(jack)
    assert statement([],tokens) == {expected,[]}
  end

  test "a do statement with implicit receiver" do
    jack = "do go();"
    expected = [
      doStatement: [
        keyword: "do",
        identifier: "go",
        symbol: "(",
        expressionList: [],
        symbol: ")",
        symbol: ";"]]

    tokens = tokenize(jack)
    assert statement([],tokens) == {expected,[]}
  end

  test "a return statement" do
    jack = "return x;"
    expected = [
      returnStatement: [
        keyword: "return",
        expression: [term: [identifier: "x"]],
        symbol: ";"]]

    tokens = tokenize(jack)
    assert statement([],tokens) == {expected,[]}
  end

  test "a single statement" do
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
