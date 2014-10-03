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

  test "ConvertToBin" do
    jack = "test/fixtures/ConvertToBin/Main.jack" |> File.read!
    expected ="test/fixtures/ConvertToBin/Main.vm" |> File.read! |> strip_instructions

    assert compile(jack) == expected
  end

  test "Square/Main" do
    jack = "test/fixtures/Square/Main.jack" |> File.read!
    expected ="test/fixtures/Square/Main.vm" |> File.read! |> strip_instructions

    assert compile(jack) == expected
  end

  test "Square/Square" do
    jack = "test/fixtures/Square/Square.jack" |> File.read!
    expected ="test/fixtures/Square/Square.vm" |> File.read! |> strip_instructions

    assert compile(jack) == expected
  end

  test "Square/SquareGame" do
    jack = "test/fixtures/Square/SquareGame.jack" |> File.read!
    expected ="test/fixtures/Square/SquareGame.vm" |> File.read! |> strip_instructions

    assert compile(jack) == expected
  end

  test "Average/Main" do
    jack = "test/fixtures/Average/Main.jack" |> File.read!
    expected ="test/fixtures/Average/Main.vm" |> File.read! |> strip_instructions

    assert compile(jack) == expected
  end
end
