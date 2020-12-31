defmodule Day6 do

  def one(answerGroups), do: solve(answerGroups, &anyAnswered/1)
  def two(answerGroups), do: solve(answerGroups, &allAnswered/1)

  def parse(input), do: input
    |> Utils.Parse.lines("\n\n")
    |> Enum.map(& String.split(&1, "\n", trim: true))

  defp solve(answerGroups, extractor), do: answerGroups
    |> Enum.map(extractor)
    |> Enum.map(&length/1)
    |> Enum.reduce(& &1 + &2)

  def anyAnswered(answers), do: answers
    |> Enum.map(& Regex.scan(~r/[a-z]/, &1))
    |> List.flatten()
    |> MapSet.new()
    |> MapSet.to_list()

  def allAnswered(answers), do: answers
    |> Enum.map(& Regex.scan(~r/[a-z]/, &1))
    |> Enum.map(& MapSet.new(&1))
    |> Enum.reduce(& MapSet.intersection(&1, &2))
    |> MapSet.to_list()

end
