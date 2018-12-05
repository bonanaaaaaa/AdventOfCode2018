defmodule Logic do
  def divide([]), do: %{}

  def divide([pos]), do: toMap(pos)

  def divide(list) do
    half_size = div(Enum.count(list), 2)
    {list_a, list_b} = Enum.split(list, half_size)

    t1 = Task.async(Logic, :divide, [list_a])
    t2 = Task.async(Logic, :divide, [list_b])

    Map.merge(Task.await(t1), Task.await(t2), fn _k, v1, v2 -> v1 + v2 end)
  end

  defp toMap(pos) do
    arr =
      for x <- pos.x1..pos.x2,
          y <- pos.y1..pos.y2,
          do: {x, y}

    Enum.reduce(arr, %{}, fn {x, y}, m -> Map.put(m, "#{x},#{y}", 1) end)
  end
end

inputRegex = ~r/#(?<id>\d+)\s@\s(?<x>\d+),(?<y>\d+):\s(?<xsize>\d+)x(?<ysize>\d+)/

# File.stream!("sample.txt")
File.stream!("input.txt")
|> Stream.map(&String.trim/1)
|> Enum.map(&Regex.named_captures(inputRegex, &1))
|> Enum.map(
  &%{
    id: &1["id"],
    x: String.to_integer(&1["x"]),
    y: String.to_integer(&1["y"]),
    xsize: String.to_integer(&1["xsize"]),
    ysize: String.to_integer(&1["ysize"])
  }
)
|> Enum.map(fn data ->
  %{
    x1: data.x + 1,
    x2: data.x + data.xsize,
    y1: data.y + 1,
    y2: data.y + data.ysize
  }
end)
|> Enum.to_list()
|> Logic.divide()
|> Map.to_list()
|> Enum.filter(fn {_k, v} -> v >= 2 end)
|> Enum.count()
|> IO.puts()
