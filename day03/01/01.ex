defmodule Logic do
  def divide(%{x1: x1, x2: x2, y1: y1, y2: y2}) when x1 == x2 and y1 == y2 do
    # IO.inspect(%{"#{x1},#{y1}" => 1})
    %{"#{x1},#{y1}" => 1}
  end

  def divide(pos) do
    first = %{
      x1: pos.x1,
      x2: lower(pos.x2, pos.x1),
      y1: pos.y1,
      y2: lower(pos.y2, pos.y1)
    }

    second = %{
      x1: upper(pos.x2, pos.x1),
      x2: pos.x2,
      y1: upper(pos.y2, pos.y1),
      y2: pos.y2
    }

    third = %{
      x1: upper(pos.x2, pos.x1),
      x2: pos.x2,
      y1: pos.y1,
      y2: lower(pos.y2, pos.y1)
    }

    forth = %{
      x1: pos.x1,
      x2: lower(pos.x2, pos.x1),
      y1: upper(pos.y2, pos.y1),
      y2: pos.y2
    }

    [first, second, third, forth]
    |> Enum.uniq()
    # |> IO.inspect()
    |> Enum.map(&divide/1)
    |> Enum.reduce(%{}, fn m, acc ->
      Map.merge(m, acc)
    end)
  end

  defp lower(m, n) do
    Float.floor((m + n) / 2) |> Kernel.trunc()
  end

  defp upper(m, n) do
    if m == n do
      m
    else
      sum = m + n

      case rem(sum, 2) do
        0 -> (Float.ceil(sum / 2) + 1) |> Kernel.trunc()
        _ -> Float.ceil(sum / 2) |> Kernel.trunc()
      end
    end
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
# |> IO.inspect()
|> Enum.map(&Logic.divide/1)
|> Enum.reduce(%{}, fn m, acc ->
  Map.merge(m, acc, fn _k, v1, v2 -> v1 + v2 end)
end)
# |> IO.inspect()
|> Map.to_list()
|> Enum.filter(fn {_k, v} -> v >= 2 end)
# |> IO.inspect()
|> Enum.count()
|> IO.puts()
