defmodule Logic do
  def place(pos, co_ord_list) do
    co_ord_list
    |> Enum.reduce(
      {
        999_999,
        false,
        nil
      },
      fn co_ord, {cur_min_distance, cur_dup, cur_min_co_ord} ->
        distance = cal_distance(co_ord, pos)
        new_min_distance = Enum.min([cur_min_distance, distance])

        dup = !(new_min_distance < cur_min_distance) && (cur_dup || cur_min_distance == distance)

        min_co_ord =
          if new_min_distance < cur_min_distance do
            co_ord
          else
            cur_min_co_ord
          end

        {
          new_min_distance,
          dup,
          min_co_ord
        }
      end
    )
  end

  def cal_distance(pos1, pos2), do: abs(pos1.x - pos2.x) + abs(pos1.y - pos2.y)
end

file_name = "input.txt"
# file_name = "sample.txt"
# File.stream!("sample.txt")
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

filtered_co_ord_str_list =
  Enum.filter(co_ord_list, fn co_ord ->
    co_ord.x != min_x && co_ord.x != max_x && co_ord.y != min_y && co_ord.y != max_y
  end)
  |> Enum.map(fn pos -> "#{pos.x},#{pos.y}" end)

pos_list =
  for x <- min_x..max_x, y <- min_y..max_y do
    %{x: x, y: y}
  end

Enum.reduce(pos_list, %{}, fn pos, m ->
  {_min_distance, dup, min_co_ord} = Logic.place(pos, co_ord_list)

  p =
    if dup do
      ""
    else
      "#{min_co_ord.x},#{min_co_ord.y}"
    end

  Map.put(m, "#{pos.x},#{pos.y}", p)
end)
|> Map.values()
|> Enum.filter(fn p -> Enum.member?(filtered_co_ord_str_list, p) end)
|> Enum.reduce(%{}, fn p, m -> Map.update(m, p, 1, &(&1 + 1)) end)
|> Map.values()
|> Enum.max()
|> IO.inspect()
