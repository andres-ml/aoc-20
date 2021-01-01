defmodule Day12 do

  def parse(input), do: input
    |> Utils.Parse.lines
    |> Enum.map(fn line ->
      [_, move, offset] = Regex.run(~r/([A-Z])(\d+)/, line)
      {move, elem(Integer.parse(offset), 0)}
    end)

  def one(moves), do: moves
    |> Enum.reduce({0, 0, 90}, &move1/2)
    |> (fn {x, y, _} -> abs(x) + abs(y) end).()

  def two(moves), do: moves
    |> Enum.reduce({{0, 0}, {-1, 10}}, &move2/2)
    |> (fn {{x, y}, _} -> abs(x) + abs(y) end).()

  defp move1(movement, ship)
  defp move1({"N", offset}, {x, y, angle}), do: {x - offset, y, angle}
  defp move1({"S", offset}, {x, y, angle}), do: {x + offset, y, angle}
  defp move1({"W", offset}, {x, y, angle}), do: {x, y - offset, angle}
  defp move1({"E", offset}, {x, y, angle}), do: {x, y + offset, angle}
  defp move1({"L", offset}, {x, y, angle}), do: {x, y, turn(angle, 360 - offset)}
  defp move1({"R", offset}, {x, y, angle}), do: {x, y, turn(angle, offset)}
  defp move1({"F", offset}, ship = {_, _, angle}), do: move1({%{0 => "N", 90 => "E", 180 => "S", 270 => "W"}[angle], offset}, ship)

  defp turn(angle, degrees), do: rem(angle + degrees, 360)

  def move2(movement, state)
  def move2({"N", offset}, {ship, {x, y}}), do: {ship, {x - offset, y}}
  def move2({"S", offset}, {ship, {x, y}}), do: {ship, {x + offset, y}}
  def move2({"W", offset}, {ship, {x, y}}), do: {ship, {x, y - offset}}
  def move2({"E", offset}, {ship, {x, y}}), do: {ship, {x, y + offset}}
  def move2({"L", offset}, {ship, waypoint}), do: {ship, rotate(waypoint, 360 - offset)}
  def move2({"R", offset}, {ship, waypoint}), do: {ship, rotate(waypoint, offset)}
  def move2({"F", offset}, {{x, y}, {wx, wy}}), do: {{x + wx*offset, y + wy*offset}, {wx, wy}}

  # each rotation to the right consists of swapping x for y and then changing the sign of y
  # we apply such transformation from 1 to 3 times, depending on the angle (90, 180, 270)
  def rotate({wx, wy}, degrees) do
    {{dx, dy}, _} = Utils.Algorithms.solve(
      {{wx, wy}, degrees},
      fn {{dx, dy}, degrees} -> {{dy, -dx}, degrees - 90} end,
      fn {_, degrees} -> degrees == 0 end
    )
    {dx, dy}
  end

end
