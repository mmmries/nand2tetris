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

  test "basic if" do
    jack = """
      class Main {
        function void main() {
          var boolean loop;
          let loop = true;
          if( loop) {
            do Memory.poke(8000 + 1, 1);
          } else {
            do Memory.poke(8000 + 1, 2);
          }
          return;
        }
      }
    """

    expected = """
      function Main.main 1
      push constant 0
      not
      pop local 0
      push local 0
      if-goto IF_TRUE0
      goto IF_FALSE0
      label IF_TRUE0
      push constant 8000
      push constant 1
      add
      push constant 1
      call Memory.poke 2
      pop temp 0
      goto IF_END0
      label IF_FALSE0
      push constant 8000
      push constant 1
      add
      push constant 2
      call Memory.poke 2
      pop temp 0
      label IF_END0
      push constant 0
      return
    """ |> strip_instructions

    assert jack |> compile == expected
  end

  test "ConvertToBin/Main" do
    integration_test("ConvertToBin/Main.jack")
  end

  test "Square/Main" do
    integration_test("Square/Main.jack")
  end

  test "Square/Square" do
    integration_test("Square/Square.jack")
  end

  test "Square/SquareGame" do
    integration_test("Square/SquareGame.jack")
  end

  test "Average/Main" do
    integration_test("Average/Main.jack")
  end

  test "Pong/Ball" do
    integration_test("Pong/Ball.jack")
  end

  test "Pong/Bat" do
    integration_test("Pong/Bat.jack")
  end

  test "Pong/PongGame" do
    integration_test("Pong/PongGame.jack")
  end

  test "Pong/Main" do
    integration_test("Pong/Main.jack")
  end

  def integration_test(jack_path) do
    jack_path = "test/fixtures/" <> jack_path
    vm_path = String.replace(jack_path, ".jack", ".vm")
    jack = jack_path |> File.read!
    expected = vm_path |> File.read! |> strip_instructions

    assert compile(jack) == expected
  end
end
