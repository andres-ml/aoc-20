Elixir implementation of 2020's [Advent of Code](adventofcode.com)

## How to run

Run either with `mix solve` or interactively through `iex`. Inputs are expected to be found under `inputs/user/<day>.txt`. You can optionally pass the path to the input file.

```
mix solve 1 one
mix solve 1 two inputs/demo/2.txt
```
```
iex -S mix
> Aoc20.solve(1, :two)
```