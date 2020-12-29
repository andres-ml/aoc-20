defmodule Day7 do

  # parses bags into a map with the form %{color => %{childColor => childQuantity}}
  defp parse(input), do: input
    |> String.split("\n", trim: true)
    |> Enum.map(& Regex.named_captures(~r/(?<color>[a-z ]+) bags contain (?<data>.+)/, &1))
    |> Enum.into(%{}, (fn %{"color" => color, "data" => data} -> {
        color,
        Regex.scan(~r/(\d+) ([a-z ]+) bags?/, data)
          |> Enum.into(%{}, fn [_match, quantity, color] -> { color, elem(Integer.parse(quantity), 0) } end)
      } end))

  @doc """
  Part one: count how many bags eventually contain a shiny gold bag
  """
  def one(input) do
    bags = parse(input)
    Enum.count(bags, fn {color, _children} -> eventuallyContains(bags, color, "shiny gold") end)
  end

  defp eventuallyContains(bags, color, target) do
    Enum.any?(bags[color], fn {childColor, _quantity} -> childColor == target or eventuallyContains(bags, childColor, target) end)
  end

  @doc """
  Part two: count how many bags inside a shiny gold bag

  Notes: barebones memoization seems kind of ugly in Elixir since you have to pass the cache around.
  It'd probably be better to use the `Agent` module to store the cache.
  """
  def two(input), do: parse(input)
    |> buildCountMap()
    |> Map.get("shiny gold")

  defp buildCountMap(bags), do: Enum.reduce(bags, %{}, fn {color, _children}, cache -> Map.merge(cache, count(bags, color, cache)) end)

  defp count(_bags, color, cache) when is_map_key(color, cache), do: cache
  defp count(bags, color, cache) do
    childCount = Enum.reduce(bags[color], 0, fn {childColor, quantity}, total ->
      cache = count(bags, childColor, cache)
      total + quantity * (1 + cache[childColor])
    end)
    Map.merge(cache, %{color => childCount})
  end

end
