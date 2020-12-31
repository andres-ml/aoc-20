defmodule Day11 do

  @moduledoc """
  Notes: the grid is copied around so often that the solution is quite slow
  """

  @seat_empty "L"
  @seat_occupied "#"
  @floor "."

  def parse(input), do: Utils.Parse.grid(input)

  def one(grid), do: solve(grid, %{
    adjacency: &direct_adjacency/2,
    threshold: 4
  })

  def two(grid), do: solve(grid, %{
    adjacency: &extended_adjacency/2,
    threshold: 5
  })

  def solve(grid, options), do: stabilize(grid, options)
    |> Map.get(:map)
    |> Map.values
    |> Enum.count(& &1 == @seat_occupied)

  def stabilize(grid, options) do
    Utils.Algorithms.solve(
      %{ grid: grid, changes: 1 },
      fn %{grid: grid} -> grid_step(grid, options) end,
      fn %{changes: n} -> n == 0 end
    ) |> Map.get(:grid)
  end

  # returns a tuple with the status of the grid after all of its seats have changed based on their adjacencies
  # as the first element, and the number of changes as the second
  defp grid_step(grid, options) do
    Enum.reduce(
      grid[:map],
      %{ grid: grid, changes: 0 },
      fn {position, current}, %{grid: %{map: map}, changes: changes} ->
        next = seat_step(grid, position, options)
        %{
          grid: %{grid | map: Map.put(map, position, next) },
          changes: (if current != next, do: changes + 1, else: changes)
        }
      end
    )
  end

  # returns the status of the seat at position `position` based on its adjacencies
  defp seat_step(grid = %{map: map}, position, %{adjacency: adjacency_function, threshold: adjacency_threshold}) do
    empty_map = Enum.into([@seat_empty, @seat_occupied, @floor], %{}, & {&1, 0})
    adjacent_map = position
      |> adjacency_function.(grid)
      |> Enum.group_by(fn p -> map[p] end)
      |> Enum.into(empty_map, fn {type, list} -> {type, length(list)} end)
    case {map[position], adjacent_map} do
      {@seat_empty, %{@seat_occupied => 0}} -> @seat_occupied
      {@seat_occupied, %{@seat_occupied => n}} when n >= adjacency_threshold -> @seat_empty
      {current, _} -> current
    end
  end

  defp direct_adjacency(position, grid), do: get_adjacencies(position, grid, fn _ -> true end)
  defp extended_adjacency(position, grid), do: get_adjacencies(position, grid, fn p -> grid[:map][p] != @floor end)

  defp get_adjacencies(position, %{n: n, m: m}, valid_adjacency?) do
    vectors = for vi <- -1..1, vj <- -1..1,
      vi != 0 or vj != 0, # skip self
      do: {vi, vj}

    within_bounds = fn {i, j} ->
      i >= 0 and i < n and
      j >= 0 and j < m
    end

    project = fn {i, j}, {vi, vj} ->
      Stream.unfold({1, nil}, fn current = {k, _found} ->
        with next <- {i + vi*k, j + vj*k} do
          cond do
            not within_bounds.(next) -> nil
            valid_adjacency?.(next) -> {current, {k, next}}
            true -> {current, {k + 1, nil}}
          end
        end
      end)
        |> Stream.map(& elem(&1, 1))
        |> Enum.find(& &1 != nil)
    end

    vectors
      |> Enum.map(& project.(position, &1))
      |> Enum.filter(& &1 != nil)
  end

end
