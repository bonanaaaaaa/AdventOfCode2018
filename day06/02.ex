defmodule Logic do
  def total_distance(pos, co_ord_list) do
    co_ord_list
    |> Enum.reduce(
      0,
      fn co_ord, sum ->
        sum + cal_distance(co_ord, pos)
      end
    )
  end

  def cal_distance(pos1, pos2), do: abs(pos1.x - pos2.x) + abs(pos1.y - pos2.y)
end

file_name = "input.txt"
max_distance = 10000
# file_name = "sample.txt"
# max_distance = 32

co_ord_list =
  File.stream!(file_name)
  |> Stream.map(&String.trim/1)
  |> Stream.map(&String.split(&1, ", "))
  |> Stream.map(fn [x, y] -> %{x: String.to_integer(x), y: String.to_integer(y)} end)
  |> Enum.to_list()

[min_x, min_y, max_x, max_y] =
  Enum.reduce(
    co_ord_list,
    [
      999_999,
      999_999,
      -1,
      -1
    ],
    fn co_ord, [min_x, min_y, max_x, max_y] ->
      [
        Enum.min([min_x, co_ord.x]),
        Enum.min([min_y, co_ord.y]),
        Enum.max([max_x, co_ord.x]),
        Enum.max([max_y, co_ord.y])
      ]
    end
  )

pos_list =
  for x <- min_x..max_x, y <- min_y..max_y do
    %{x: x, y: y}
  end

pos_list
|> Enum.filter(fn pos -> Logic.total_distance(pos, co_ord_list) < max_distance end)
|> Enum.count()
|> IO.inspect()

# Enum.map(placed_map, &IO.inspect/1)

# Map.values(placed_map)
# |> Enum.filter(fn p -> Enum.member?(filtered_co_ord_str_list, p) end)
# |> Enum.reduce(%{}, fn p, m -> Map.update(m, p, 1, &(&1 + 1)) end)
# |> Map.values()
# |> Enum.max()
# |> IO.inspect()
