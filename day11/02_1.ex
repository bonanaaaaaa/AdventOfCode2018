defmodule Logic do
  def solution(pos_map, size) do
    grid_size = 300

    pos_list =
      for x <- 1..(grid_size - size + 1),
          y <- 1..(grid_size - size + 1),
          do: %{x: x, y: y}

    real_pos_map =
      pos_list
      |> Enum.reduce(%{}, fn pos, m ->
        Map.put(m, "#{pos.x},#{pos.y},#{size}", get_real_power(pos, pos_map, size))
      end)

    pos_list
    |> Enum.reduce(%{pos: nil, max: -999_999}, fn pos, data ->
      power = Map.get(real_pos_map, "#{pos.x},#{pos.y},#{size}")

      if power > data.max do
        %{
          pos: pos,
          size: size,
          max: power
        }
      else
        data
      end
    end)
  end

  def init_pos_map(pos_list) do
    pos_list
    |> Enum.reduce(%{}, fn pos, m ->
      p = get_power(pos)
      # IO.inspect("#{pos.x},#{pos.y} -> #{p}")
      Map.put(m, "#{pos.x},#{pos.y}", p)
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

  def get_real_power(pos, pos_map, size) do
    gen_pos_keys(pos, size)
    |> Enum.reduce(0, fn k, power ->
      power + Map.get(pos_map, k)
    end)
  end

  def gen_pos_keys(pos, size) do
    min_x = Enum.max([1, pos.x])
    max_x = Enum.min([300, pos.x + size - 1])
    min_y = Enum.max([1, pos.y])
    max_y = Enum.min([300, pos.y + size - 1])

    for x <- min_x..max_x, y <- min_y..max_y, do: "#{x},#{y}"
  end
end

pos_list = for x <- 1..300, y <- 1..300, do: %{x: x, y: y}

init_pos_map = Logic.init_pos_map(pos_list)

2..300
|> Task.async_stream(
  fn size ->
    Logic.solution(init_pos_map, size)
  end,
  timeout: 1000 * 60 * 5
)
|> Enum.reduce(%{pos: nil, max: -999_999}, fn {:ok, pos}, data ->
  if pos.max > data.max do
    %{
      pos: pos.pos,
      size: pos.size,
      max: pos.max
    }
  else
    data
  end
end)
|> IO.inspect()
