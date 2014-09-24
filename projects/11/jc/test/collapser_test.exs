defmodule CollapserTest do
  use ExUnit.Case
  import Jack.Collapser, only: [collapse: 1]

  test "it collapses an if statement into a map" do
    ast = [ifStatement: [
      keyword: "if", symbol: "(", expression: [term: [identifier: %{category: "var", definition: false, index: 1, name: "loop"}]],
      symbol: ")", symbol: "{", statements: [
        doStatement: [keyword: "do", identifier: %{category: "subroutine", class: "Memory", definition: false, name: "poke"}, symbol: "(", expressionList: [expression: [term: [integerConstant: "8000"], symbol: "+", term: [integerConstant: "1"]], symbol: ",", expression: [term: [integerConstant: "1"]]], symbol: ")", symbol: ";"]],
      symbol: "}", keyword: "else", symbol: "{", statements: [
        doStatement: [keyword: "do", identifier: %{category: "subroutine", class: "Memory", definition: false, name: "poke"}, symbol: "(", expressionList: [expression: [term: [integerConstant: "8000"], symbol: "+", term: [integerConstant: "1"]], symbol: ",", expression: [term: [integerConstant: "2"]]], symbol: ")", symbol: ";"]],
      symbol: "}"]]

    expected = [ifStatement: %{
      index: 0,
      condition: [term: [identifier: %{category: "var", definition: false, index: 1, name: "loop"}]],
      true_statements: [doStatement: [keyword: "do", identifier: %{category: "subroutine", class: "Memory", definition: false, name: "poke"}, symbol: "(", expressionList: [expression: [term: [integerConstant: "8000"], symbol: "+", term: [integerConstant: "1"]], symbol: ",", expression: [term: [integerConstant: "1"]]], symbol: ")", symbol: ";"]],
      false_statements: [doStatement: [keyword: "do", identifier: %{category: "subroutine", class: "Memory", definition: false, name: "poke"}, symbol: "(", expressionList: [expression: [term: [integerConstant: "8000"], symbol: "+", term: [integerConstant: "1"]], symbol: ",", expression: [term: [integerConstant: "2"]]], symbol: ")", symbol: ";"]]
    }]

    assert ast |> collapse == expected
  end

  test "it collapses a while statement into a map" do
    ast = [whileStatement: [keyword: "while", symbol: "(", expression: [term: [identifier: %{category: "argument", definition: false, index: 1, name: "length"}], symbol: ">", term: [integerConstant: "0"]], symbol: ")", symbol: "{", statements: [doStatement: [keyword: "do", identifier: %{category: "subroutine", class: "Memory", definition: false, name: "poke", numArgs: 2}, symbol: "(", expressionList: [expression: [term: [identifier: %{category: "argument", definition: false, index: 0, name: "startAddress"}]], symbol: ",", expression: [term: [identifier: %{category: "argument", definition: false, index: 2, name: "value"}]]], symbol: ")", symbol: ";"], letStatement: [keyword: "let", identifier: %{category: "argument", definition: false, index: 1, name: "length"}, symbol: "=", expression: [term: [identifier: %{category: "argument", definition: false, index: 1, name: "length"}], symbol: "-", term: [integerConstant: "1"]], symbol: ";"], letStatement: [keyword: "let", identifier: %{category: "argument", definition: false, index: 0, name: "startAddress"}, symbol: "=", expression: [term: [identifier: %{category: "argument", definition: false, index: 0, name: "startAddress"}], symbol: "+", term: [integerConstant: "1"]], symbol: ";"]], symbol: "}"]]

    expected = [whileStatement: %{
      index: 0,
      condition: [term: [identifier: %{category: "argument", definition: false, index: 1, name: "length"}], symbol: ">", term: [integerConstant: "0"]],
      statements: [doStatement: [keyword: "do", identifier: %{category: "subroutine", class: "Memory", definition: false, name: "poke", numArgs: 2}, symbol: "(", expressionList: [expression: [term: [identifier: %{category: "argument", definition: false, index: 0, name: "startAddress"}]], symbol: ",", expression: [term: [identifier: %{category: "argument", definition: false, index: 2, name: "value"}]]], symbol: ")", symbol: ";"], letStatement: [keyword: "let", identifier: %{category: "argument", definition: false, index: 1, name: "length"}, symbol: "=", expression: [term: [identifier: %{category: "argument", definition: false, index: 1, name: "length"}], symbol: "-", term: [integerConstant: "1"]], symbol: ";"], letStatement: [keyword: "let", identifier: %{category: "argument", definition: false, index: 0, name: "startAddress"}, symbol: "=", expression: [term: [identifier: %{category: "argument", definition: false, index: 0, name: "startAddress"}], symbol: "+", term: [integerConstant: "1"]], symbol: ";"]]
    }]

    assert ast |> collapse == expected
  end
end
