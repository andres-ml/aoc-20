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

## Implementation details

Each day's solution lies on the corresponding module under `lib/days/<day>.ex`. Each of those modules must implement three functions:
* `parse`: a convenience function to parse the input, since we always transform it from a string into data we can work with
* `one`: solver of part 1
* `two`: solver of part 2

Both `one` and `two` receive the parsed input as their sole argument.