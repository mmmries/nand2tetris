defmodule Mix.Tasks.Jack.Compile do
  use Mix.Task
  import Jack.Compiler, only: [compile: 1]

  @shortdoc "given a filepath, it reads and compiles the jack code and prints the vm code to STDOUT"

  def run(argv) do
    argv |>
      List.first |>
      File.read! |>
      compile |>
      Enum.join("\n") |>
      IO.puts
  end
end
