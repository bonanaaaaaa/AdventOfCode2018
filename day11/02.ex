defmodule Logic do
  def solution() do
    grid_size = 300

    pos_list_with_size =
      for s <- 2..3,
          x <- 1..(grid_size - s + 1),
          y <- 1..(grid_size - s + 1),
          do: %{x: x, y: y, size: s}

    pos_list = for x <- 1..grid_size, y <- 1..grid_size, do: %{x: x, y: y}

    Enum.count(pos_list) |> IO.puts()
    Enum.count(pos_list_with_size) |> IO.puts()

    init_pos_map =
      pos_list
      |> Enum.reduce(%{}, fn pos, m ->
        p = get_power(pos)
        # IO.inspect("#{pos.x},#{pos.y} -> #{p}")
        Map.put(m, "#{pos.x},#{pos.y},1", p)
      end)

    IO.puts("done1")

    real_pos_map =
      pos_list_with_size
      |> Enum.reduce(init_pos_map, fn pos, m ->
        Map.put(m, "#{pos.x},#{pos.y},#{pos.size}", get_real_power(pos, m))
      end)

    # IO.inspect(real_pos_map)
    IO.puts("done2")

    Map.keys(real_pos_map)
    |> Enum.reduce(%{pos: nil, max: -999_999}, fn k, data ->
      power = Map.get(real_pos_map, k)

      if power > data.max do
        %{
          pos: k,
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
    # keys = gen_pos_keys(pos)
    # Enum.count(keys) |> IO.puts()
    # IO.inspect(pos)

    # keys
    # |> IO.inspect()
    # |> Enum.reduce(0, fn k, power ->
    #   power + Map.get(pos_map, k, 0)
    # end)
    x = pos.x
    y = pos.y
    size = pos.size

    min_x = x
    max_x = x + size
    min_y = y
    max_y = y + size

    key = "#{x},#{y},#{size}"

    if Map.has_key?(pos_map, key) do
      Map.get(pos_map, key)
    else
      mid_x = Float.ceil((min_x + max_x) / 2) |> trunc()
      mid_y = Float.ceil((min_y + max_y) / 2) |> trunc()
      mid_size = Float.ceil(size / 2) |> trunc()

      # IO.inspect(pos)
      # IO.puts(mid_x)
      # IO.puts(mid_y)
      # IO.puts(mid_size)
      # IO.puts("=============")

      arr = [
        get_real_power(
          %{
            x: x,
            y: y,
            size: mid_size
          },
          pos_map
        ),
        get_real_power(
          %{
            x: mid_x,
            y: y,
            size: size - mid_size
          },
          pos_map
        ),
        get_real_power(
          %{
            x: x,
            y: mid_y,
            size: size - mid_size
          },
          pos_map
        ),
        get_real_power(
          %{
            x: mid_x,
            y: mid_y,
            size: size - mid_size
          },
          pos_map
        )
      ]

      # IO.inspect(arr)

      Enum.sum(arr)
    end
  end

  def gen_pos_keys(pos) do
    # min_x = Enum.max([1, pos.x])
    # max_x = Enum.min([300, pos.x + pos.size - 1])
    # min_y = Enum.max([1, pos.y])
    # max_y = Enum.min([300, pos.y + pos.size - 1])

    x = pos.x
    y = pos.y
    size = pos.size
    min_x = Enum.min([300, x])
    min_y = Enum.min([300, y])
    max_x = Enum.max([x + size - 1, 1])
    max_y = Enum.max([y + size - 1, 1])

    first = for xi <- min_x..max_x, do: "#{xi},#{max_y},1"
    second = for yi <- min_y..(max_y - 1), do: "#{max_x},#{yi},1"
    third = ["#{x},#{y},#{size - 1}"]

    first ++ second ++ third

    # for x <- min_x..max_x, y <- min_y..max_y, do: "#{x},#{y}"
    # for x <- min_x..max_x, y <- min_y..max_y, do: "#{x},#{y}"
  end
end

Logic.solution()
|> IO.inspect()
