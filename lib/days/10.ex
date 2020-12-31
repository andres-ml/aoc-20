defmodule Day10 do

  use Memoize

  @initial_joltage 0
  @device_joltage_offset 3
  @compatible_joltage_offset 3

  # sorted joltages, including initial and device
  def parse(input), do: input
    |> String.split("\n", trim: true)
    |> Enum.map(& elem(Integer.parse(&1), 0))
    |> Enum.sort()
    |> (fn joltages -> [@initial_joltage] ++ joltages ++ [Enum.max(joltages) + @device_joltage_offset] end).()

  # simply count the differences from one to the next
  def one([first | rest]) do
    {_, distribution} = Enum.reduce(
      rest,
      {first, %{1 => 0, 2 => 0, 3 => 0}},
      fn joltage, {current, distribution} ->
        difference = joltage - current
        {joltage, %{distribution | difference => distribution[difference] + 1}}
      end
    )

    distribution[1] * distribution[3]
  end

  # count combinations starting from the first joltage
  def two([first | rest]) do
    Application.ensure_all_started(:memoize)
    combinations(first, rest)
  end

  # memoized adapter combinations
  def combinations(joltage, rest) do
    Memoize.Cache.get_or_run({__MODULE__, :resolve, [joltage]}, fn ->
      # take compatible adapters
      compatible = rest
        |> Enum.take_while(& &1 - joltage <= @compatible_joltage_offset)
        |> Enum.with_index(1)

      # sum their combinations
      case compatible do
        [] -> 1
        compatible -> compatible
          |> Enum.map(fn {compatible_joltage, index} -> combinations(compatible_joltage, Enum.slice(rest, index..-1)) end)
          |> Enum.reduce(& &1 + &2)
      end
    end)
  end

end
