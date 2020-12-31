defmodule Utils.Parse do

  def lines(string, separator \\ "\n"), do: String.split(string, separator, trim: true)

  # parses a grid into a map with keys n(row length), m(col length) and map(map of position -> item)
  def grid(string), do: grid(string, & &1)
  def grid(string, transform) do
    rows = [head | _] = lines(string) |> Enum.map(&String.graphemes/1)
    n = length(rows)
    m = length(head)
    grid = for {row, i} <- Enum.with_index(rows),
      {char, j} <- Enum.with_index(row),
      into: %{},
      do: {{i, j}, transform.(char)}
    %{ n: n, m: m, map: grid }
  end

end
