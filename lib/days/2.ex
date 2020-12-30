defmodule Day2 do

  def parse(input) do
    parseLine = fn line ->
      captures = Regex.named_captures(~r/(?<min>\d+)-(?<max>\d+) (?<character>[a-z]): (?<password>[a-z]+)/, line)
      %{
        "min" => String.to_integer(captures["min"]),
        "max" => String.to_integer(captures["max"]),
        "character" => captures["character"],
        "password" => captures["password"],
      }
    end
    input
      |> String.split("\n", trim: true)
      |> Enum.map(& parseLine.(&1))
  end

  def one(lines), do: lines |> Enum.filter(&validOne/1) |> length()
  def two(lines), do: lines |> Enum.filter(&validTwo/1) |> length()

  # specified character's number of occurrences must be within specified range
  defp validOne(data) do
    occurrences = data["password"]
      |> String.graphemes()
      |> Enum.count(fn char -> char == data["character"] end)
    data["min"] <= occurrences and occurrences <= data["max"]
  end

  # exactly one of the two indices must contain the specified character
  defp validTwo(data) do
    is = fn index -> String.at(data["password"], index - 1) == data["character"] end
    is.(data["min"]) != is.(data["max"])
  end

end
