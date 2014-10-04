defmodule Mix.Tasks.Jack.CompileDir do
  use Mix.Task
  import Jack.Compiler, only: [compile: 1]

  @shortdoc "given a dirname it compiles all jack files in that directory and writes them to the corresponding .vm files"

  def run(argv) do
    dir = argv |>
      List.first |>
      Path.absname
    glob = dir <> "/*.jack"
    glob |> Path.wildcard |> Enum.each(&compile_and_write/1)
  end

  def compile_and_write(filename) do
    dest = String.replace(filename,".jack",".vm")
    instructions = filename |> File.read! |> compile |> Enum.join("\n")
    File.write(dest, instructions)
  end
end
