defmodule Mix.Tasks.Solve do

  use Mix.Task

  def run([day, part]), do: run([day, part, nil])
  def run([day, part, pathToInput]) do
    Aoc20.solve(
      String.to_integer(day),
      String.to_atom(part),
      pathToInput
    ) |> IO.puts
  end

end
