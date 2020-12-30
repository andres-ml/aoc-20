defmodule Mix.Tasks.Verify do

  use Mix.Task

  def run(_args) do
    for day <- 1..25 do
      IO.write("Day #{day}")
      for part <- [:one, :two] do
        IO.write("\t#{part}: ")
        try do
          Aoc20.solve(day, part)
          IO.write("✓")
        rescue
          _ in [ArgumentError, UndefinedFunctionError] -> IO.write("—")
          _ -> IO.write("error")
        end
      end
      IO.puts("")
    end
  end

end
