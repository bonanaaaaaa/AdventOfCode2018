defmodule Logic do
  def match(c1, c2) do
    String.downcase(c1) == String.downcase(c2) && c1 != c2
  end

  def produce(str) do
    case String.length(str) do
      0 ->
        [""]

      1 ->
        [str]

      n ->
        half = div(n, 2)
        {front, back} = String.split_at(str, half)

        # t1 = Task.async(Logic, :produce, [front])
        # t2 = Task.async(Logic, :produce, [back])

        # merge(Task.await(t1), Task.await(t2))

        merge(
          produce(front),
          produce(back)
        )
    end
  end

  defp first(e) do
    case Enum.take(e, 1) do
      [] -> ""
      [x] -> x
    end
  end

  defp last(e) do
    case Enum.take(e, -1) do
      [] -> ""
      [x] -> x
    end
  end

  defp merge(front, back) do
    if match(last(front), first(back)) do
      merge(Enum.slice(front, 0..-2), Enum.slice(back, 1..-1))
    else
      Enum.concat(front, back)
    end
  end
end

[str] =
  File.stream!("input.txt")
  |> Stream.map(&String.trim/1)
  |> Enum.to_list()

min = String.length(str)

str
|> String.graphemes()
|> Enum.reduce(%{}, fn ch, acc ->
  Map.put(acc, String.downcase(ch), true)
end)
|> Map.keys()
# |> IO.inspect()
|> Enum.map(fn ch ->
  String.replace(str, ~r/[#{String.capitalize(ch)}#{ch}]/, "")
end)
|> Task.async_stream(fn s ->
  # s |> Logic.produce() |> String.length()
  s |> Logic.produce() |> Enum.count()
end)
# |> Enum.map(fn s -> Task.async(Logic, :find, [s]) end)
# |> Enum.map(fn t -> Task.await(t) end)
|> Enum.reduce(min, fn {:ok, n}, min -> Enum.min([n, min]) end)
# |> Enum.min_by(&(Logic.find(&1) |> String.length()))
|> IO.inspect()
