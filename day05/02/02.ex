defmodule Logic do
  def match(c1, c2) do
    regex = ~r/([A-Z][a-z]|[a-z][A-Z])/
    String.downcase(c1) == String.downcase(c2) && String.match?(c1 <> c2, regex)
  end

  def find(str, index \\ 0) do
    if index + 1 == String.length(str) - 1 do
      str
    else
      if match(String.at(str, index), String.at(str, index + 1)) do
        front =
          if index - 1 < 0 do
            ""
          else
            String.slice(str, 0..(index - 1))
          end

        new_str = front <> String.slice(str, (index + 2)..-1)

        find(new_str, Enum.max([0, index - 1]))
      else
        find(str, index + 1)
      end
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
|> IO.inspect()
|> Enum.map(fn ch ->
  String.replace(str, ~r/[#{String.capitalize(ch)}#{ch}]/, "")
end)
|> Task.async_stream(
  fn s ->
    s |> Logic.find() |> String.length()
  end,
  timeout: 600_000
)
# |> Enum.map(fn s -> Task.async(Logic, :find, [s]) end)
# |> Enum.map(fn t -> Task.await(t) end)
|> Enum.reduce(min, fn {:ok, n}, min -> Enum.min([n, min]) end)
# |> Enum.min_by(&(Logic.find(&1) |> String.length()))
|> IO.inspect()
