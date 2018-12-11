defmodule Logic do
  def solution() do
    pos_list = for x <- 1..300, y <- 1..300, do: %{x: x, y: y}

    pos_map =
      pos_list
      |> Enum.reduce(%{}, fn pos, m ->
        p = get_power(pos)
        # IO.inspect("#{pos.x},#{pos.y} -> #{p}")
        Map.put(m, "#{pos.x},#{pos.y}", p)
      end)

    real_pos_map =
      pos_list
      |> Enum.reduce(%{}, fn pos, m ->
        Map.put(m, "#{pos.x},#{pos.y}", get_real_power(pos, pos_map))
      end)

    pos_list
    |> Enum.reduce(%{pos: nil, max: -999_999}, fn pos, data ->
      power = Map.get(real_pos_map, "#{pos.x},#{pos.y}")

      if power > data.max do
        %{
          pos: pos,
          max: power
        }
      else
        data
      end
    end)
  end

  def get_power(pos) do
    serial = 7989
    # serial = 18
    rack_id = pos.x + 10
    power_start = (rack_id * pos.y + serial) * rack_id
    power = div(power_start, 100) |> rem(10)
    power - 5
  end

  def get_real_power(pos, pos_map) do
    gen_pos_keys(pos)
    |> Enum.reduce(0, fn k, power ->
      power + Map.get(pos_map, k)
    end)
  end

  def gen_pos_keys(pos) do
    min_x = Enum.max([1, pos.x])
    max_x = Enum.min([300, pos.x + 2])
    min_y = Enum.max([1, pos.y])
    max_y = Enum.min([300, pos.y + 2])

    for x <- min_x..max_x, y <- min_y..max_y, do: "#{x},#{y}"
  end
end

Logic.solution()
|> IO.inspect()
