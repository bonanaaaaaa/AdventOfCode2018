defmodule Logic do
  def count(str) do
    str
    |> String.graphemes()
    |> Enum.reduce(%{}, fn c, acc ->
      Map.update(acc, c, 1, &(&1 + 1))
    end)
    |> Map.values()
    |> Enum.reduce(%{2 => 0, 3 => 0}, fn n, acc ->
      case n do
        2 -> Map.put(acc, 2, 1)
        3 -> Map.put(acc, 3, 1)
        _ -> acc
      end
    end)
  end
end

File.stream!("input.txt")
|> Stream.map(&String.trim/1)
|> Enum.to_list()
|> Enum.map(&Logic.count/1)
|> IO.inspect()
|> Enum.reduce(%{2 => 0, 3 => 0}, fn m, acc ->
  Map.merge(m, acc, fn _k, v1, v2 -> v1 + v2 end)
end)
|> IO.inspect()
|> Map.values()
|> Enum.reduce(1, fn n, acc -> n * acc end)
|> IO.inspect()
