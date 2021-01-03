defmodule Day16 do

  # parse input into 3 elements: rules, ticket, nearby_tickets
  def parse(input) do
    [rules, [_, ticket], [_ | nearby_tickets]] = input
      |> Utils.Parse.lines("\n\n")
      |> Enum.map(&Utils.Parse.lines/1)
    %{
      rules: rules |> Enum.map(&parseRule/1),
      ticket: ticket |> parseTicket(),
      nearby_tickets: nearby_tickets |> Enum.map(&parseTicket/1)
    }
  end

  # parse each rule into a tuple with its name and its list of validation ranges
  defp parseRule(rule) do
    [key] = Regex.run(~r/[a-z ]+/, rule)
    ranges = Regex.scan(~r/\d+/, rule)
      |> List.flatten()
      |> Enum.map(&Utils.Integer.parse/1)
      |> Enum.chunk_every(2)
    {key, ranges}
  end

  # parse each ticket into a list of numbers
  defp parseTicket(ticket), do: ticket
    |> String.split(",")
    |> Enum.map(&Utils.Integer.parse/1)

  # Part one: get all invalid values, and sum them
  def one(%{rules: rules, nearby_tickets: tickets}), do: tickets
    |> Enum.map(fn ticket -> getInvalidValues(rules, ticket) end)
    |> List.flatten()
    |> Enum.reduce(0, & &1 + &2)

  # validates `value` agains the ranges defined by the specified rule
  defp validate(_rule = {_key, ranges}, value), do: Enum.any?(ranges, fn [from, to] -> from <= value and value <= to end)

  # filters the numbers in `values` that do not match any rule
  defp getInvalidValues(rules, values) do
    Enum.filter(values, fn value ->
      not Enum.any?(rules, fn rule -> validate(rule, value) end)
    end)
  end

  # Part two: find out which position corresponds to each field,
  # then multiply the values of your ticket that correspond to fields beginning
  # with "departure"
  def two(data = %{ticket: ticket}) do
    solve_field_positions(data)
      |> Enum.filter(fn {key, _} -> String.starts_with?(key, "departure") end)
      |> Enum.map(fn {_key, index} -> Enum.at(ticket, index) end)
      |> Enum.reduce(& &1 * &2)
  end

  defp solve_field_positions(%{rules: rules, ticket: ticket, nearby_tickets: nearby_tickets}) do
    # discard invalid tickets and add our own ticket
    valid_tickets = Enum.filter(nearby_tickets, fn values -> getInvalidValues(rules, values) == [] end)
    tickets = [ticket | valid_tickets]

    # finds the set of fields which are valid for ALL specified numbers
    get_matching_fields_set = fn numbers -> numbers
      |> Enum.map(fn number -> rules
        |> Enum.filter(fn rule -> validate(rule, number) end)
        |> Enum.map(fn {key, _} -> key end)
        |> MapSet.new()
      end)
      |> Enum.reduce(& MapSet.intersection(&1, &2))
    end

    # for each position, get the set of fields that validate
    # the numbers found in that position among ALL tickets
    fields_by_index = 0 .. length(rules)-1
      |> Enum.map(fn index -> {index, Enum.map(tickets, fn values -> Enum.at(values, index) end)} end)
      |> Enum.into(%{}, fn {index, numbers} -> {index, get_matching_fields_set.(numbers)} end)

    solve(fields_by_index, length(rules))
  end

  # match each field to its position through backtracking
  defp solve(_, 0), do: %{}
  defp solve(sets, _) when map_size(sets) == 0, do: nil
  defp solve(sets, remaining) do
    # find most restrictive position; i.e. that for which there are the fewest possible fields that match it
    {set_index, set} = Enum.min_by(sets, fn {_, set} -> MapSet.size(set) end)
    subsets = Map.delete(sets, set_index)

    # find the first key for which exists a subsolution (the remaining fields can be assigned to the remaining positions)
    solution = Utils.Algorithms.solve(
      { Enum.to_list(set), nil },
      fn {[key | rest], _} ->
        # remove the current key as an option to other fields
        subsolution = subsets
          |> Enum.into(%{}, fn {index, set} -> {index, MapSet.delete(set, key)} end)
          |> solve(remaining - 1)
        case subsolution do
          nil -> {rest, nil} # no solution, keep going with remaining keys
          subsolution -> {key, subsolution} # return the key and the solution
        end
      end,
      fn
        {[], nil} -> false # no keys remain
        {_, subsolution} -> subsolution != nil # we found a solution
      end
    )

    case solution do
      {_, nil} -> nil # no solution exists
      {key, subsolution} -> Map.put(subsolution, key, set_index) # combine the subsolution with our match
    end
  end

end
