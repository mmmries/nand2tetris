defmodule InstructionTest do
  use ExUnit.Case
  import Jack.Instruction, only: [from_ast: 1]

  test "string constant" do
    ast = [term: [stringConstant: "OHAI"]]
    assert from_ast(ast) == ["push constant 4","call String.new 1","push constant 79","call String.appendChar 2","push constant 72","call String.appendChar 2","push constant 65","call String.appendChar 2","push constant 73","call String.appendChar 2"]
  end
end
