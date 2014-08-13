defmodule ParserTest do
  use ExUnit.Case
  import Jack.Tokenizer, only: [tokenize: 1]
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

  test "understand class variable declarations" do
    jack = """
    class Jack {
      field boolean debug, crash;
      static Jack singleton;
    }
    """

    expected = {:class, [
      {:keyword, "class"},
      {:identifier, "Jack"},
      {:symbol, "{"},
      {:classVarDec, [
        {:keyword, "field"},
        {:keyword, "boolean"},
        {:identifier, "debug"},
        {:symbol,","},
        {:identifier, "crash"},
        {:symbol, ";"}
      ]},
      {:classVarDec, [
        {:keyword, "static"},
        {:identifier, "Jack"},
        {:identifier, "singleton"},
        {:symbol, ";"}
      ]},
      {:symbol, "}"}
    ]}

    assert jack |> tokenize |> parse == expected
  end

  test "understands different types of subroutines" do
    jack = """
    class Jack {
      constructor Jack new(){return;}
      function void quack(){return;}
      method int bark(){ return 5; }
    }
    """

    expected = {:class, [
      keyword: "class",
      identifier: "Jack",
      symbol: "{",
      subroutineDec: [
        keyword: "constructor",
        identifier: "Jack",
        identifier: "new",
        symbol: "(",
        parameterList: [],
        symbol: ")",
        subroutineBody: [
          symbol: "{",
          statements: [
            returnStatement: [
              keyword: "return",
              symbol: ";",
            ]
          ],
          symbol: "}",
        ]
      ],
      subroutineDec: [
        keyword: "function",
        keyword: "void",
        identifier: "quack",
        symbol: "(",
        parameterList: [],
        symbol: ")",
        subroutineBody: [
          symbol: "{",
          statements: [
            returnStatement: [
              keyword: "return",
              symbol: ";",
            ]
          ],
          symbol: "}",
        ]
      ],
      subroutineDec: [
        keyword: "method",
        keyword: "int",
        identifier: "bark",
        symbol: "(",
        parameterList: [],
        symbol: ")",
        subroutineBody: [
          symbol: "{",
          statements: [
            returnStatement: [
              keyword: "return",
              expression: [
                term: [
                  integerConstant: "5"
                ]
              ],
              symbol: ";",
            ]
          ],
          symbol: "}",
        ]
      ],
      symbol: "}",
    ]}

    assert jack |> tokenize |> parse == expected
  end
end
