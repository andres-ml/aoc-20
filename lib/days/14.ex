defmodule Day14 do

  use Bitwise

  @size 36

  def parse(input), do: input
    |> Utils.Parse.lines()
    |> Enum.map(&parseLine/1)

  # mask line
  defp parseLine(line = "mask" <> _) do
    [mask | _] = Regex.run(~r/[01X]+/, line)
    {"mask", mask}
  end

  # memory line
  defp parseLine(line = "mem" <> _) do
    data = Regex.named_captures(~r/mem\[(?<position>\d+)\] = (?<number>[0-9]+)/, line)
    {"mem", Enum.into(data, %{}, fn {k, number} -> {k, Utils.Integer.parse(number, 10)} end)}
  end

  # run all operations and sum memory values; used in both parts
  defp solve(operations, callback), do: operations
    |> Enum.reduce(%{mask: nil, memory: %{}}, callback)
    |> Map.get(:memory)
    |> Map.values()
    |> Enum.reduce(& &1 + &2)

  @doc """
  Part one: mask applied to values, X doesn't change the bits
  """
  def one(operations), do: solve(operations, &executeV1/2)

  defp executeV1({"mask", mask}, state), do: %{state | mask: mask}
  defp executeV1({"mem", %{"position" => position, "number" => number}}, state = %{mask: mask, memory: memory}) do
    %{state | memory: Map.put(memory, position, apply_mask(mask, number))}
  end

  defp apply_mask(mask, number), do: number
    &&& mask |> String.replace("X", "1") |> Utils.Integer.parse(2) # masks the 0s
    ||| mask |> String.replace("X", "0") |> Utils.Integer.parse(2) # masks the 1s

  @doc """
  Part two: mask applied to memory addresses, but this time 0 doesn't change the bits and X creates
  a "quantum" state where it can be considered as both 0 and 1.
  """
  def two(operations), do: solve(operations, &executeV2/2)

  defp executeV2({"mask", mask}, state), do: %{state | mask: mask}
  defp executeV2({"mem", %{"position" => position, "number" => number}}, state = %{mask: mask, memory: memory}) do
    %{state | memory: Enum.reduce(quantum(mask, position), memory, fn address, memory -> Map.put(memory, address, number) end)}
  end

  # Expands all quantum possibilities of applying `mask` to position.
  # Result size scales exponentially based on the number of 'X's present in the mask
  defp quantum(mask, position) do
    Enum.reduce(
      Enum.zip(
        String.graphemes(mask),
        String.graphemes(Integer.to_string(position, 2) |> String.pad_leading(@size, "0"))
      ),
      [""],
      fn {mask_bit, bit}, combinations ->
        qbit = case {mask_bit, bit} do
          {"X", _} -> ["0", "1"] # floating
          {"1", _} -> ["1"] # overriden
          {"0", bit} -> [bit] # unchanged
        end
        for qbits <- combinations, bit <- qbit, do: qbits <> bit
      end
    ) |> Enum.map(& Utils.Integer.parse(&1, 2))
  end

end
