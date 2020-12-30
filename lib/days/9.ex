defmodule Day9 do

  @preamble_size 25

  def parse(input), do: input
    |> String.split("\n", trim: true)
    |> Enum.map(& elem(Integer.parse(&1), 0))

  def one(numbers) do
    vulnerable = fn set, number -> not Enum.any?(set, & MapSet.member?(set, number - &1)) end

    step = fn %{set: set, queue: queue, list: [current | items]} ->
      match = if vulnerable.(set, current), do: current, else: nil
      {{_, out}, queue} = :queue.out(queue)
      set = MapSet.delete(set, out)
      %{
        set: MapSet.put(set, current),
        queue: :queue.in(current, queue),
        list: items,
        match: match
      }
    end

    {preamble, rest} = Enum.split(numbers, @preamble_size)
    state = %{set: MapSet.new(preamble), queue: :queue.from_list(preamble), list: rest, match: nil}

    Utils.solve(
      state,
      step,
      fn %{match: match} -> match != nil end
    ) |> Map.get(:match)
  end

  def two(numbers = [first | [second | rest]]) do
    target = one(numbers)

    state = %{
      sum: first + second,
      queue: :queue.from_list([first, second]),
      list: rest
    }

    step = fn
      %{sum: sum, queue: queue, list: list = [next | rest]} -> cond do
        sum == target -> {sum, queue, []}
        sum < target or :queue.len(queue) < 2 -> %{
          sum: sum + next,
          queue: :queue.in(next, queue),
          list: rest
        }
        sum > target ->
          {{:value, out}, queue} = :queue.out(queue)
          %{
            sum: sum - out,
            queue: queue,
            list: list
          }
      end
    end

    sequence = Utils.solve(
      state,
      step,
      fn %{sum: sum} -> sum == target end
    ) |> Map.get(:queue)
      |> :queue.to_list()

    Enum.max(sequence) + Enum.min(sequence)
  end

end
