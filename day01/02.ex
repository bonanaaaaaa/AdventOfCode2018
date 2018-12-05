File.stream!("input.txt")
|> Stream.map(&String.trim/1)
|> Stream.map(&String.to_integer/1)
|> Enum.to_list()
|> Stream.cycle()
|> Enum.reduce_while(%{sum: 0, map: %{}}, fn x, %{map: map, sum: sum} ->
  if Map.has_key?(map, sum),
    do: {:halt, sum},
    else: {:cont, %{sum: sum + x, map: Map.put(map, sum, true)}}
end)
|> IO.inspect()
