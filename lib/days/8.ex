defmodule Day8 do

  def parse(input), do: input
    |> String.split("\n", trim: true)
    |> Enum.map(& Regex.run(~r/([a-z ]+) ([-+]\d+)/, &1))
    |> Enum.with_index()
    |> Enum.into(%{}, fn {[_match, op, argument], index} -> {index, %{
      op: String.to_atom(op),
      arguments: [ elem(Integer.parse(argument), 0) ]
    }} end)

  @doc """
  Part one: execute the instruction set until we find a loop, then return the `acc` value
  """
  def one(instructions), do: run(instructions) |> elem(1)

  @doc """
  Part two: since there are no conditional jumps, re-visiting an instruction means there's a loop.
  We simply must find the permutation (jmp <-> nop) for which the execution ends instead of looping
  """
  def two(instructions), do: permutations(instructions)
    |> Stream.map(& run(&1))
    |> Stream.filter(fn {ip, _acc, _visited} -> ip == map_size(instructions) end)
    |> Enum.at(0)
    |> elem(1)

  # Executes all instructions until the instruction pointer (ip) is out of bounds or an instruction is re-visited
  defp run(instructions, {ip, acc, visited} \\ {0, 0, MapSet.new()}), do: {ip, acc, visited}
    |> Stream.iterate(& execute(instructions, &1))
    |> Stream.drop_while(fn {ip, _acc, visited} -> ip < map_size(instructions) and not MapSet.member?(visited, ip) end)
    |> Enum.at(0)

  # Executes a single instruction
  defp execute(instructions, {ip, acc, visited}) do
    {nextIp, nextAcc} = apply(__MODULE__, instructions[ip][:op], [{ip, acc} | instructions[ip][:arguments]])
    {nextIp, nextAcc, MapSet.put(visited, ip)}
  end

  # Finds all permutations of the original instruction set, where each permutation is a single jmp swapped for a nop or viceversa
  defp permutations(instructions) do
    for {index, %{op: operation, arguments: arguments}} <- instructions, operation == :jmp or operation == :nop, do:
      %{instructions | index => %{
        op: (if operation == :jmp, do: :nop, else: :jmp),
        arguments: arguments
      }}
  end

  # operations
  def acc({ip, acc}, offset), do: {ip + 1, acc + offset}
  def jmp({ip, acc}, offset), do: {ip + offset, acc}
  def nop({ip, acc}, _), do: {ip + 1, acc}

end
