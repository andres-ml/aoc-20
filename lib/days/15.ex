defmodule Day15 do

  def parse(input), do: input
    |> Utils.Parse.lines(",")
    |> Enum.map(&Utils.Integer.parse/1)

  def one(numbers), do: numbers
    |> play()
    |> Enum.at(2020)

  # slow
  def two(numbers), do: numbers
    |> play()
    |> Enum.at(30_000_000)

  defp play(numbers) do
    Stream.unfold(
      %{turn: 0, last_spoken: nil, cache: %{}},
      fn c = %{turn: turn, last_spoken: last_spoken, cache: cache} ->
        spoken = cond do
          turn < length(numbers) -> Enum.at(numbers, turn)
          true -> case Map.get(cache, last_spoken) do
            nil -> 0
            spoken_at -> (turn - 1) - spoken_at
          end
        end
        {c, %{
          turn: turn + 1,
          last_spoken: spoken,
          cache: Map.put(cache, last_spoken, turn - 1),
        } }
      end
    ) |> Stream.map(& &1[:last_spoken])
  end

end
