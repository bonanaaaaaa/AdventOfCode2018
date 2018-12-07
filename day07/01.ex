defmodule Logic do
  def sort(g) do
    in_degree =
      g
      |> Map.keys()
      |> Enum.reduce(%{}, fn v, m -> Map.put(m, v, 0) end)
      |> Map.merge(
        g
        |> Map.values()
        |> Enum.reduce([], fn v, arr -> arr ++ Tuple.to_list(v) end)
        |> List.flatten()
        |> Enum.reduce(%{}, fn v, m -> Map.update(m, v, 1, &(&1 + 1)) end)
      )

    q =
      in_degree
      |> Map.keys()
      |> Enum.filter(fn k -> Map.get(in_degree, k) == 0 end)
      |> Enum.sort()

    cal(g, in_degree, q, {}) |> Tuple.to_list() |> Enum.join()
  end

  defp cal(_g, _in_degree, [], ans), do: ans

  defp cal(g, in_degree, q, ans) do
    {u, new_q} = q |> List.pop_at(0)
    new_ans = Tuple.append(ans, u)

    neighbor = Map.get(g, u, {}) |> Tuple.to_list()
    new_in_degree = cal_in_degree(neighbor, in_degree)

    new_q2 =
      (new_q ++ neighbor)
      |> Enum.filter(fn n -> Map.get(new_in_degree, n) == 0 end)
      |> Enum.sort()

    cal(g, new_in_degree, new_q2, new_ans)
  end

  defp cal_in_degree(nodes, in_degree) do
    nodes |> Enum.reduce(in_degree, fn n, in_d -> Map.update!(in_d, n, &(&1 - 1)) end)
  end
end

file_name = "input.txt"
# file_name = "sample.txt"

input_regex = ~r/Step\s(?<parent>[A-Z])[a-z\s]+(?<child>[A-Z])[a-z\s]+\./

File.stream!(file_name)
|> Stream.map(&String.trim/1)
|> Stream.map(&Regex.named_captures(input_regex, &1))
|> Stream.map(&{&1["parent"], &1["child"]})
|> Enum.to_list()
|> Enum.reduce(%{}, fn {p, c}, g ->
  Map.update(g, p, {c}, &Tuple.append(&1, c))
end)
|> IO.inspect()
|> Logic.sort()
|> IO.inspect()
