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
end
