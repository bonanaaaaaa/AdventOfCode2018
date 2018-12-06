defmodule Logic do
  def match(c1, c2) do
    regex = ~r/([A-Z][a-z]|[a-z][A-Z])/
    String.downcase(c1) == String.downcase(c2) && String.match?(c1 <> c2, regex)
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

  defp nil_to_blank(char) do
    case char do
      nil -> ""
      char -> char
    end
  end

  defp merge(front, back) do
    {f, f_list} = List.pop_at(front, -1)
    {b, b_list} = List.pop_at(back, 0)

    if match(nil_to_blank(f), nil_to_blank(b)) do
      merge(f_list, b_list)
    else
      front ++ back
    end
  end
end

[str] =
  File.stream!("input.txt")
  |> Stream.map(&String.trim/1)
  |> Enum.to_list()

min_val = String.length(str)

str
|> String.graphemes()
|> Enum.reduce(%{}, fn ch, acc ->
  Map.put(acc, String.downcase(ch), true)
end)
|> Map.keys()
|> Enum.map(fn ch ->
  String.replace(str, ~r/[#{String.capitalize(ch)}#{ch}]/, "")
end)
|> Task.async_stream(fn s ->
  s |> Logic.produce() |> Enum.count()
end)
|> Enum.reduce(min_val, fn {:ok, n}, min -> Enum.min([n, min]) end)
|> IO.inspect()
