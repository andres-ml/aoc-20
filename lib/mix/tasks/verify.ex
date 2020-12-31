defmodule Mix.Tasks.Verify do

  use Mix.Task

  def test_day(day, part) do
    try do
      Aoc20.solve(day, part)
      "✓"
    rescue
      _ in [ArgumentError, UndefinedFunctionError] -> "—"
      _ -> "error"
    end
  end

  def run(_args) do
    tasks = for day <- 1..25,
      part <- [:one, :two],
      into: %{},
      do: { {day, part}, Task.async(fn -> test_day(day, part) end) }

    for day <- 1..25 do
      part_one = Task.await(tasks[{day, :one}], :infinity)
      part_two = Task.await(tasks[{day, :two}], :infinity)
      IO.puts("Day #{day}\tone: #{part_one}\ttwo: #{part_two}")
    end
  end

end
