defmodule InstructionTest do
  use ExUnit.Case
  import Jack.Instruction, only: [from_ast: 1]

  test "string constant" do
    ast = [term: [stringConstant: "OHAI"]]
    assert from_ast(ast) == ["push constant 4","call String.new 1","push constant 79","call String.appendChar 2","push constant 72","call String.appendChar 2","push constant 65","call String.appendChar 2","push constant 73","call String.appendChar 2"]
  end

  test "complex expression" do
    # (~(lengthx < 0)) & (bouncingDirection = 1) | (lengthx < 0) & (bouncingDirection = (-1))
    ast = [term:
      [symbol: "(", expression: [
        term: [
          symbol: "~", term: [symbol: "(", expression: [
              term: [identifier: %{category: "field", definition: false, index: 2, name: "lengthx", type: "int"}],
              symbol: "<",
              term: [integerConstant: "0"]], symbol: ")"]]], symbol: ")"],
        symbol: "&",
        term: [symbol: "(", expression: [
          term: [identifier: %{category: "argument", definition: false, index: 1, name: "bouncingDirection", type: "int"}],
          symbol: "=",
          term: [integerConstant: "1"]], symbol: ")"],
        symbol: "|",
        term: [symbol: "(", expression: [
          term: [identifier: %{category: "field", definition: false, index: 2, name: "lengthx", type: "int"}],
        symbol: "<",
        term: [integerConstant: "0"]], symbol: ")"],
        symbol: "&",
        term: [symbol: "(", expression: [
          term: [identifier: %{category: "argument", definition: false, index: 1, name: "bouncingDirection", type: "int"}],
          symbol: "=",
          term: [symbol: "(", expression: [
            symbol: "-",
            term: [integerConstant: "1"]], symbol: ")"]], symbol: ")"]]

    assert from_ast(ast) == ["push this 2","push constant 0","lt","not","push argument 1","push constant 1","eq","and","push this 2","push constant 0","lt","or","push argument 1","push constant 1","neg","eq","and"]
  end
end
