defmodule Utils.Integer do

  def parse(n, base \\ 10), do: elem(Integer.parse(n, base), 0)

end
