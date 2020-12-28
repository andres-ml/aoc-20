defmodule Day5 do

  def one(input), do: parse(input) |> Enum.map(&seat/1) |> Enum.max()
  def two(input) do
    map = for id <- parse(input), into: %{}, do: { seat(id), nil }
    0..floor(:math.pow(2, 10))
      |> Enum.filter(& !Map.has_key?(map, &1) and Map.has_key?(map, &1-1) and Map.has_key?(map, &1+1))
      |> List.first()
  end

  defp parse(input), do: String.split(input, "\n", trim: true)

  defp seat(id) do
    toBinary = fn string, range, map -> string
      |> String.slice(range)
      |> String.graphemes()
      |> Enum.map(& map[&1])
      |> Enum.join("")
    end

    binsum = fn bitstring -> bitstring
      |> Integer.parse(2)
      |> elem(0)
    end

    row = id |> toBinary.(0..6, %{"F" => 0, "B" => 1}) |> binsum.()
    column = id |> toBinary.(6..-1, %{"L" => 0, "R" => 1}) |> binsum.()

    row * 8 + column
  end

end
