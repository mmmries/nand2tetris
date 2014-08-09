defmodule JackCompilerTest do
  use ExUnit.Case
  import JackCompiler, only: [tokenize: 1]

  test "basic tokenization" do
    jack = """
      if (x < 0)
        {let state = "negative";}
    """
    tokens = [
      {:keyword, "if"},
      {:symbol, "("},
      {:identifier, "x"},
      {:symbol, "<"},
      {:integerConstant, "0"},
      {:symbol, ")"},
      {:symbol, "{"},
      {:keyword, "let"},
      {:identifier, "state"},
      {:symbol, "="},
      {:stringConstant, "negative"},
      {:symbol, ";"},
      {:symbol, "}"},
    ]
    assert tokenize(jack) == tokens
  end

  test "single line comment" do
    jack = """
      // ohai guyz &%*(&)(*
      if (x < 0)
        {let state = "negative";}
    """
    tokens = [
      {:keyword, "if"},
      {:symbol, "("},
      {:identifier, "x"},
      {:symbol, "<"},
      {:integerConstant, "0"},
      {:symbol, ")"},
      {:symbol, "{"},
      {:keyword, "let"},
      {:identifier, "state"},
      {:symbol, "="},
      {:stringConstant, "negative"},
      {:symbol, ";"},
      {:symbol, "}"},
    ]
    assert tokenize(jack) == tokens
  end

  test "multi-line comment" do
    jack = """
      /**
        *  ohai guyz &%*(&)(*
        *  Woot Woot woor
       */
      if (x < 0)
        {let state = "negative";}
    """
    tokens = [
      {:keyword, "if"},
      {:symbol, "("},
      {:identifier, "x"},
      {:symbol, "<"},
      {:integerConstant, "0"},
      {:symbol, ")"},
      {:symbol, "{"},
      {:keyword, "let"},
      {:identifier, "state"},
      {:symbol, "="},
      {:stringConstant, "negative"},
      {:symbol, ";"},
      {:symbol, "}"},
    ]
    assert tokenize(jack) == tokens
  end

  test "class tokenization" do
    jack = """
      class Main {
          function void main() {
              var SquareGame game;

              let game = game;
              do game.run();
          }
      }
    """

    tokens = [
      {:keyword, "class"},
      {:identifier, "Main"},
      {:symbol, "{"},
      {:keyword, "function"},
      {:keyword, "void"},
      {:identifier, "main"},
      {:symbol, "("},
      {:symbol, ")"},
      {:symbol, "{"},
      {:keyword, "var"},
      {:identifier, "SquareGame"},
      {:identifier, "game"},
      {:symbol, ";"},
      {:keyword, "let"},
      {:identifier, "game"},
      {:symbol, "="},
      {:identifier, "game"},
      {:symbol, ";"},
      {:keyword, "do"},
      {:identifier, "game"},
      {:symbol, "."},
      {:identifier, "run"},
      {:symbol, "("},
      {:symbol, ")"},
      {:symbol, ";"},
      {:symbol, "}"},
      {:symbol, "}"},
    ]

    assert tokenize(jack) == tokens
  end
end
