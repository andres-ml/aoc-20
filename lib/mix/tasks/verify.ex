defmodule Mix.Tasks.Verify do

  use Mix.Task

  def run(_args) do
    for day <- 1..25, part <- [:one, :two] do
      IO.write("Day #{day} part #{part}: ")
      try do
        Aoc20.solve(day, part)
        IO.puts("✓")
      rescue
        _ in ArgumentError -> IO.puts("—")
        _ -> IO.puts("error")
      end
    end
  end

end
