defmodule Utils.Parse do

  def lines(string, separator \\ "\n"), do: String.split(string, separator, trim: true)

end
