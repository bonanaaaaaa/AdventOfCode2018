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

    alpha = for n <- ?A..?Z, do: <<n::utf8>>

    time_map = Enum.zip(alpha, (60 + 1)..(60 + 26)) |> Map.new()
    # time_map = Enum.zip(alpha, 1..26) |> Map.new()

    {q1, avia_tasks} = q |> Enum.split(5)

    cal(g, in_degree, time_map, q1, avia_tasks, 0, "")
  end

  defp cal(_g, _in_degree, _time_map, [], [], time, order), do: {time, order}

  defp cal(g, in_degree, time_map, q, avia_tasks, time, order) do
    {u, new_q} = q |> List.pop_at(0)
    time_used = time_map |> Map.get(u)
    new_time = time + time_used
    new_order = order <> u

    neighbor = Map.get(g, u, {}) |> Tuple.to_list()
    new_in_degree = cal_in_degree(neighbor, in_degree)

    # Calculate time when job `u` done
    new_time_map =
      new_q |> Enum.reduce(time_map, fn k, m -> Map.update!(m, k, &(&1 - time_used)) end)

    # Filter out the job that done at the same time
    new_q2 = new_q |> Enum.filter(fn q -> Map.get(new_time_map, q) != 0 end)

    # Add task to avialable tasks queue
    new_avia_tasks =
      neighbor
      |> Enum.filter(fn n -> Map.get(new_in_degree, n) == 0 end)
      |> Enum.concat(avia_tasks)

    # Add new task to q
    {new_q3, new_avia_tasks2} = (new_q2 ++ new_avia_tasks) |> Enum.split(5)

    # find the job that will done next
    new_q4 =
      new_q3 |> Enum.sort(fn a, b -> Map.get(new_time_map, a) < Map.get(new_time_map, b) end)

    cal(g, new_in_degree, new_time_map, new_q4, new_avia_tasks2, new_time, new_order)
  end

  defp cal_in_degree(nodes, in_degree) do
    nodes |> Enum.reduce(in_degree, fn n, in_d -> Map.update!(in_d, n, &(&1 - 1)) end)
  end

  defp cal_time() do
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
