defmodule Day13 do

  def parse(input) do
    [start, ids] = Utils.Parse.lines(input)
    to_integer = & elem(Integer.parse(&1), 0)
    {
      to_integer.(start),
      ids
        |> String.split(",", trim: true)
        |> Enum.with_index
        |> Enum.filter(fn {n, _} -> n != "x" end)
        |> Enum.map(fn {n, index} -> {to_integer.(n), index} end)
    }
  end

  def one({start, ids}) do
    {id, wait} = ids
      |> Enum.map(& elem(&1, 0))
      |> Enum.map(& {&1, rem(&1 - rem(start, &1), &1)})
      |> Enum.min_by(& elem(&1, 1))
    id * wait
  end

  def two({_, ids}) do
    [{id, _} | rest] = ids
    {_, offset} = Enum.reduce(
      rest,
      {id, 0},
      fn {id, index}, {factor, timestamp} -> {
        Utils.Math.lcm(factor, id),
        Utils.Algorithms.solve(
          timestamp,
          fn timestamp -> timestamp + factor end,
          fn timestamp -> rem(timestamp + index, id) == 0 end
        )
      } end
    )
    offset
  end

end
