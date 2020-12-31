defmodule Day3 do

  @tree "#"

  def parse(input) do
    lines = input |> Utils.Parse.lines |> Enum.map(&String.graphemes/1)
    m = length(lines)
    n = length(List.first(lines))
    grid = for i <- 0..m-1, j <- 0..n-1,
      into: %{},
      do: { {j, i}, Enum.at(Enum.at(lines, i), j) }
    %{"map" => grid, "N" => n, "M" => m}
  end

  def one(map), do: trees(map, {3, 1})
  def two(map) do
    velocities = [
      {1, 1},
      {3, 1},
      {5, 1},
      {7, 1},
      {1, 2},
    ]
    velocities
      |> Enum.map(& trees(map, &1))
      |> Enum.reduce(& &1 * &2)
  end

  defp trees(map, velocity), do: trajectory(map, velocity) |> Enum.count(& &1 == @tree)

  defp trajectory(data, velocity, position \\ {0, 0})
  defp trajectory(%{"M" => depth}, _, {_, py}) when py >= depth, do: []
  defp trajectory(data, velocity = {vx, vy}, position = {px, py}), do: [data["map"][position] | trajectory(data, velocity, { rem(px + vx, data["N"]), py + vy })]

end
