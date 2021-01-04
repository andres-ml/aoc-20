defmodule Day17 do

  # parse active positions
  def parse(input), do: input
    |> Utils.Parse.grid
    |> Map.get(:map)
    |> Enum.filter(fn {_position, cell} -> cell == "#" end)
    |> Enum.map(fn {position, _} -> position end)

  def one(active), do: active
    |> Enum.into(MapSet.new(), fn {x, y} -> {x, y, 0} end)
    |> solve()

  def two(active), do: active
    |> Enum.into(MapSet.new(), fn {x, y} -> {x, y, 0, 0} end)
    |> solve()

  defp solve(active), do: active
    |> Stream.iterate(&cycle/1)
    |> Enum.at(6)
    |> MapSet.size()

  defp cycle(active) do
    # Iterate through active positions to find those which should be deactivated,
    # and accumulate ALL inactive neighbour positions
    %{deactivated: deactivated, neighbours: inactive_neighbours} = Enum.reduce(
      active,
      %{deactivated: MapSet.new(), neighbours: []},
      fn position, %{deactivated: deactivated, neighbours: neighbours} ->
        {active_neighbours, inactive_neighbours} = position
          |> adjacencies()
          |> Enum.split_with(fn neighbour -> MapSet.member?(active, neighbour) end)
        %{
          neighbours: neighbours ++ inactive_neighbours,
          deactivated: case length(active_neighbours) do
            2 -> deactivated
            3 -> deactivated
            _ -> MapSet.put(deactivated, position)
          end
        }
      end
    )

    # Group neighbours by themselves so we know how many active nodes they were neighbours of
    # Those that appear exactly 3 times should be activated
    activated = inactive_neighbours
      |> Enum.group_by(& &1)
      |> Enum.filter(fn {_position, times} -> length(times) == 3 end)
      |> Enum.map(fn {position, _times} -> position end)
      |> MapSet.new()

    active
      |> MapSet.difference(deactivated)
      |> MapSet.union(activated)
  end

  # 3d adjacencies
  defp adjacencies({x, y, z}) do
    for i <- -1..1, j <- -1..1, k <- -1..1,
      {i, j, k} != {0, 0, 0},
      do: {x + i, y + j, z + k}
  end

  # 4d adjacencies
  defp adjacencies({x, y, z, w}) do
    for i <- -1..1, j <- -1..1, k <- -1..1, l <- -1..1,
      {i, j, k, l} != {0, 0, 0, 0},
      do: {x + i, y + j, z + k, w + l}
  end

end
