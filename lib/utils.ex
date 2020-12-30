defmodule Utils do

  # continously applies `step` over `state` until `condition(state)` is true
  def solve(state, step, condition) do
    stream = Stream.unfold({state, false}, fn
      {_state, true} -> nil
      current = {state, _done} -> cond do
        condition.(state) -> { current, {state, true} }
        true -> { current, {step.(state), false} }
      end
    end)

    stream
      |> Enum.at(-1) # last element is the solved one
      |> elem(0) # drop the flag
  end

end
