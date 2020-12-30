defmodule Aoc20 do

  def solve(day, part, inputPath \\ nil) do
    solver = loadModule("Day#{day}")
    input = readInput(day, inputPath)
    apply(solver, part, [apply(solver, :parse, [input])])
  end

  # Dynamically load elixir module by name
  defp loadModule(name), do: String.to_existing_atom("Elixir.#{name}")

  # Read the day's input
  defp readInput(day, inputPath), do: File.read!(inputPath || Path.join(["inputs", "user", "#{day}.txt"]))

end
