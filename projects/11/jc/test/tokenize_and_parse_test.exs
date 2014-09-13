defmodule Jack.TokenizeAndParseTest do
  use ExUnit.Case
  import Jack.Tokenizer, only: [tokenize: 1]
  import Jack.Parser, only: [parse: 1]
  import Mix.Tasks.Parse, only: [token_to_xml: 1]

  test "tokenize Square/Main" do
    tokenize_test("test/fixtures/Square/Main")
  end

  test "tokenize Square/Square" do
    tokenize_test("test/fixtures/Square/Square")
  end

  test "tokenize Square/SquareGame" do
    tokenize_test("test/fixtures/Square/SquareGame")
  end

  test "tokenize ArrayTest/Main" do
    tokenize_test("test/fixtures/ArrayTest/Main")
  end

  test "parse Square/Main" do
    parse_test("test/fixtures/Square/Main")
  end

  test "parse Square/Square" do
    parse_test("test/fixtures/Square/Square")
  end

  test "parse Square/SquareGame" do
    parse_test("test/fixtures/Square/SquareGame")
  end

  test "parse ArrayTest/Main" do
    parse_test("test/fixtures/ArrayTest/Main")
  end

  def parse_test(path) do
    ast = (path<>".jack") |>
      File.read! |>
      tokenize |>
      parse
    parsed_xml = {:class, ast} |>
      token_to_xml |>
      remove_whitespace
    expected_xml = (path<>".xml") |> File.read! |> remove_whitespace
    assert parsed_xml == expected_xml
  end

  def tokenize_test(path) do
    tokens = (path<>".jack") |>
      File.read! |>
      tokenize
    generated_xml = {:tokens, tokens} |> token_to_xml |> remove_whitespace
    expected_xml = (path<>"T.xml") |> File.read! |> remove_whitespace
    assert generated_xml == expected_xml
  end

  defp remove_whitespace(str) do
    String.replace str, ~r/\s/, ""
  end
end
