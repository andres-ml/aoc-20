defmodule Aoc20.MixProject do

  use Mix.Project

  def project do
    [
      app: :aoc20,
      version: "0.1.0",
      elixir: "~> 1.5",
      elixirc_paths: ["lib"],
      aliases: aliases(),
      deps: deps()
    ]
  end

  def deps do
    [
      {:memoize, "~> 1.3"}
    ]
  end

  defp aliases do
    [

    ]
  end

end
