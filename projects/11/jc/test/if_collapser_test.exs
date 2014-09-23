defmodule IfCollapserTest do
  use ExUnit.Case
  import Jack.IfCollapser, only: [collapse: 1]

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
end
