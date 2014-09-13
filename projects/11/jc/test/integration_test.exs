defmodule IntegrationTest do
  use ExUnit.Case
  import Jack.Compiler, only: [compile: 1]

  def strip_instructions(vm) do
    vm |> String.split("\n") |> Enum.map(&String.strip/1) |> Enum.reject(&( &1 == "" ))
  end

  test "Seven" do
    jack = """
      class Main {
         function void main() {
             do Output.printInt(1 + (2 * 3));
             return;
         }
      }
    """

    expected = """
      function Main.main 0
      push constant 1
      push constant 2
      push constant 3
      call Math.multiply 2
      add
      call Output.printInt 1
      pop temp 0
      push constant 0
      return
    """ |> strip_instructions

    assert compile(jack) == expected
  end
end
