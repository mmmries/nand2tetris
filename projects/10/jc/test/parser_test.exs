defmodule ParserTest do
  use ExUnit.Case
  import Jack.Parser, only: [parse: 1]

  test "basic parse" do
    tokens = [
      keyword: "class",
      identifier: "Main",
      symbol: "{",
      keyword: "function",
      keyword: "void",
      identifier: "main",
      symbol: "(",
      symbol: ")",
      symbol: "{",
      keyword: "var",
      identifier: "SquareGame",
      identifier: "game",
      symbol: ";",
      keyword: "let",
      identifier: "game",
      symbol: "=",
      identifier: "game",
      symbol: ";",
      keyword: "do",
      identifier: "game",
      symbol: ".",
      identifier: "run",
      symbol: "(",
      symbol: ")",
      symbol: ";",
      keyword: "do",
      identifier: "game",
      symbol: ".",
      identifier: "dispose",
      symbol: "(",
      symbol: ")",
      symbol: ";",
      keyword: "return",
      symbol: ";",
      symbol: "}",
      symbol: "}"
    ]

    parsed = {:class, [
      {:keyword, "class"},
      {:identifier, "Main"},
      {:symbol, "{"},
      {:subroutineDec, [
        {:keyword, "function"},
        {:keyword, "void"},
        {:identifier, "main"},
        {:symbol, "("},
        {:parameterList, []},
        {:symbol, ")"},
        {:subroutineBody, [
          {:symbol, "{"},
          {:varDec, [
            {:keyword, "var"},
            {:identifier, "SquareGame"},
            {:identifier, "game"},
            {:symbol, ";"}
          ]},
          {:statements, [
            {:letStatement, [
              {:keyword, "let"},
              {:identifier, "game"},
              {:symbol, "="},
              {:expression, [
                {:term, [
                  {:identifier, "game"}
                ]}
              ]},
              {:symbol, ";"}
            ]},
            {:doStatement, [
              {:keyword, "do"},
              {:identifier, "game"},
              {:symbol, "."},
              {:identifier, "run"},
              {:symbol, "("},
              {:expressionList, []},
              {:symbol, ")"},
              {:symbol, ";"}
            ]},
            {:doStatement, [
              {:keyword, "do"},
              {:identifier, "game"},
              {:symbol, "."},
              {:identifier, "dispose"},
              {:symbol, "("},
              {:expressionList, []},
              {:symbol, ")"},
              {:symbol, ";"}
            ]},
            {:returnStatement, [
              {:keyword, "return"},
              {:symbol, ";"}
            ]},
          ]},
          {:symbol,"}"},
        ]},
      ]},
      {:symbol,"}"},
    ]}

    assert parse(tokens) == parsed
  end
end
