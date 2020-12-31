defmodule Day7 do

  # parses bags into a map with the form %{color => %{childColor => childQuantity}}
  def parse(input), do: input
    |> Utils.Parse.lines
    |> Enum.map(& Regex.named_captures(~r/(?<color>[a-z ]+) bags contain (?<data>.+)/, &1))
    |> Enum.into(%{}, (fn %{"color" => color, "data" => data} -> {
        color,
        Regex.scan(~r/(\d+) ([a-z ]+) bags?/, data)
          |> Enum.into(%{}, fn [_match, quantity, color] -> { color, elem(Integer.parse(quantity), 0) } end)
      } end))

  @doc """
  Part one: count how many bags eventually contain a shiny gold bag
  """
  def one(bags), do: Enum.count(bags, fn {color, _children} -> eventuallyContains(bags, color, "shiny gold") end)

  defp eventuallyContains(bags, color, target) do
    Enum.any?(bags[color], fn {childColor, _quantity} -> childColor == target or eventuallyContains(bags, childColor, target) end)
  end

  @doc """
  Part two: count how many bags inside a shiny gold bag

  Notes: barebones memoization seems kind of ugly in Elixir since you have to pass the cache around.
  It'd probably be better to use the `Agent` module to store the cache.
  """
  def two(bags), do: bags
    |> Enum.reduce(%{}, fn {color, _children}, cache -> Map.merge(cache, count(bags, color, cache)) end)
    |> Map.get("shiny gold")

  defp count(_bags, color, cache) when is_map_key(color, cache), do: cache
  defp count(bags, color, cache) do
    childCount = Enum.reduce(bags[color], 0, fn {childColor, quantity}, total ->
      cache = count(bags, childColor, cache)
      total + quantity * (1 + cache[childColor])
    end)
    Map.merge(cache, %{color => childCount})
  end

end
