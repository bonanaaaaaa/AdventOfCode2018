defmodule Recur do
  def dedup(arr, data \\ %{value: 999})

  def dedup(arr, data) when length(arr) == 0 do
    s1 = data.str.s1
    s2 = data.str.s2

    s =
      0..String.length(s1)
      |> Enum.reduce("", fn i, str ->
        if String.at(s1, i) == String.at(s2, i) do
          "#{str}#{String.at(s1, i)}"
        else
          str
        end
      end)

    Map.put(data, :s, s)
  end

  def dedup(arr, data) do
    # IO.inspect(arr)
    [s | tail] = arr
    d = inner(s, tail, String.length(s), %{})

    if d.value < data.value do
      dedup(tail, %{value: d.value, str: d.str})
    else
      dedup(tail, data)
    end
  end

  defp inner(_, arr, min, s_map) when length(arr) == 0 do
    # IO.inspect(s_map)
    %{value: min, str: s_map}
  end

  defp inner(s1, arr, min, s_map) do
    [s2 | tail] = arr
    v = compare(s1, s2)

    new_min = Enum.min([v, min])

    cond do
      new_min == 0 -> inner(s1, tail, min, s_map)
      new_min != min -> inner(s1, tail, new_min, %{s1: s1, s2: s2})
      true -> inner(s1, tail, min, s_map)
    end
  end

  defp compare(s1, s2) do
    0..String.length(s1)
    |> Enum.reduce(0, fn n, count ->
      if String.at(s1, n) != String.at(s2, n) do
        count + 1
      else
        count
      end
    end)
  end
end

File.stream!("input.txt")
|> Stream.map(&String.trim/1)
|> Enum.to_list()
|> Recur.dedup()
|> IO.inspect()
