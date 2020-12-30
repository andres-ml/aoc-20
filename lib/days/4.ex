defmodule Day4 do

  @keys ["byr", "iyr", "eyr", "hgt", "hcl", "ecl", "pid", "cid"]
  @optional ["cid"]

  def parse(input) do
    input
      |> String.split("\n\n", trim: true)
      |> Enum.map(fn data -> Regex.scan(~r/([a-z]+):(\S+)/, data)
        |> Enum.into(%{}, fn [_, key, value] -> {key, value} end)
      end)
  end

  def one(passports), do: Enum.count(passports, &validOne/1)
  def two(passports) do
    rules = [
      {"byr", & validRange(&1, 1920, 2002)},
      {"iyr", & validRange(&1, 2010, 2020)},
      {"eyr", & validRange(&1, 2020, 2030)},
      {"hgt", &validHeight/1},
      {"hcl", &validHairColor/1},
      {"ecl", &validEyeColor/1},
      {"pid", &validPassportId/1},
    ]

    validate = fn data, {key, validator} -> is_map_key(data, key) and validator.(data[key]) end
    validateAll = fn data -> Enum.all?(rules, fn rule -> validate.(data, rule) end) end
    Enum.count(passports, validateAll)
  end

  defp validOne(data), do: Enum.all?(@keys -- @optional, & is_map_key(data, &1))

  defp validRange(number, from, to) do
    try do
      n = String.to_integer(number)
      from <= n and n <= to
    rescue
      _ -> false
    end
  end

  defp validHeight(value) do
    case Regex.run(~r/(\d+)([a-z]+)/, value) do
      [_, n, "cm"] -> validRange(n, 150, 193)
      [_, n, "in"] -> validRange(n, 59, 76)
      _ -> false
    end
  end

  defp validHairColor(value), do: Regex.match?(~r/^#[a-f0-9]{6}$/, value)

  defp validEyeColor(value), do: Enum.member?(["amb", "blu", "brn", "gry", "grn", "hzl", "oth"], value)

  defp validPassportId(value), do: Regex.match?(~r/^[0-9]{9}$/, value)

end
