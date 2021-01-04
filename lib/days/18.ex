defmodule Day18 do

  @moduledoc """
  Not proud of how this turned out but I'm kind of burned out at the moment.
  """

  def parse(input), do: input
    |> Utils.Parse.lines()
    |> Enum.map(fn line -> line
      |> String.replace(["(", ")"], fn c -> " #{c} " end)
      |> String.split(" ", trim: true)
      |> Enum.map(fn token -> case Integer.parse(token) do
        :error -> String.to_atom(token)
        {n, _} -> n
      end end)
    end)

  def one(lines), do: lines
    |> Enum.map(& &1
      |> parenthesize()
      |> build1()
      |> eval()
    )
    |> Enum.reduce(& &1 + &2)

  def two(lines), do: lines
    |> Enum.map(& &1
      |> parenthesize()
      |> build2()
      |> eval()
    )
    |> Enum.reduce(& &1 + &2)

  defp parenthesize(list) do
    Enum.reduce(
      list,
      [ [] ],
      fn
        :"(", list -> [[] | list]
        :")", [a, b | list] -> [b ++ [a] | list]
        t, [h | rest] -> [h ++ [t] | rest]
      end
    ) |> List.first()
  end

  defp build1([a, operator, b]), do: {operator, build1(a), build1(b)}
  defp build1([a, operator, b | rest]), do: build1([ build1([a, operator, b]) | rest ])
  defp build1(n), do: n

  defp build2([a, :+, b]), do: {:+, build2(a), build2(b)}
  defp build2([a, :+, b | rest]), do: build2([ build2([a, :+, b]) | rest ])
  defp build2([a, :* | rest]), do: {:*, build2(a), build2(rest)}
  defp build2([n]), do: build2(n)
  defp build2(n), do: n

  defp eval(number) when is_integer(number), do: number
  defp eval({operator, left, right}), do: apply(Kernel, operator, [eval(left), eval(right)])

end
