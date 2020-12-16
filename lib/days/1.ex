defmodule Day1 do

  def one(input), do: solve(input, 2, 2020)
  def two(input), do: solve(input, 3, 2020)

  def solve(input, size, target) do
    numbers = input
      |> String.split("\n", trim: true)
      |> Enum.map(&String.to_integer/1)

    case subsetsThatAddUpTo(size, numbers, target) do
      [subset | _] -> Enum.reduce(subset, &Kernel.*/2)
      _ -> "No solution"
    end
  end

  # returns a list of subsets of numbers of size `size` that exactly sum `remaining`
  def subsetsThatAddUpTo(size, items, remaining, current \\ []) do
    cond do
      remaining == 0 and size == 0 -> [current]
      remaining <= 0  or size == 0 -> []
      true -> items
        |> Enum.with_index
        |> Enum.map(fn {number, index} -> subsetsThatAddUpTo(size - 1, Enum.slice(items, index + 1 .. -1), remaining - number, [number | current]) end)
        |> Enum.filter(fn list -> length(list) > 0 end)
        |> Enum.map(fn [list | _] -> list end)
    end
  end

end
