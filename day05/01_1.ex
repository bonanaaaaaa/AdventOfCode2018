defmodule Logic do
  def match(c1, c2) do
    regex = ~r/([A-Z][a-z]|[a-z][A-Z])/
    String.downcase(c1) == String.downcase(c2) && String.match?(c1 <> c2, regex)
  end

  def produce(str) do
    case String.length(str) do
      0 ->
        ""

      1 ->
        str

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

  defp first(s) do
    case String.first(s) do
      nil -> ""
      x -> x
    end
  end

  defp last(s) do
    case String.last(s) do
      nil -> ""
      x -> x
    end
  end

  defp merge(front, back) do
    if match(last(front), first(back)) do
      merge(String.slice(front, 0..-2), String.slice(back, 1..-1))
    else
      front <> back
    end
  end
end

[str] =
  File.stream!("input.txt")
  |> Stream.map(&String.trim/1)
  |> Enum.to_list()

Logic.produce(str)
# |> IO.inspect()
|> String.length()
|> IO.inspect()
