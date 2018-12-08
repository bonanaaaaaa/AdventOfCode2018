defmodule Node8 do
  defstruct [:child, :metadata, :child_no, :data]
end

defmodule Logic do
  def find(num_list) do
    {extracted_data, tail_num_list} = Enum.split(num_list, 2)
    [child, metadata] = extracted_data

    root = %Node8{
      child: child,
      metadata: metadata,
      child_no: child
    }

    stack = [root]

    map = run(tail_num_list, stack)
    calculate("", map)
  end

  defp run(num_list, stack, graph \\ %{})

  defp run([], [], graph), do: graph

  defp run(num_list, stack, graph) do
    {node, tail_stack} = List.pop_at(stack, -1)

    case node.child do
      0 ->
        {metadata_list, tail_num_list} = Enum.split(num_list, node.metadata)
        new_node = %Node8{node | data: metadata_list}
        run(tail_num_list, tail_stack, Map.put(graph, toKey(tail_stack), new_node))

      n ->
        {extracted_data, tail_num_list} = Enum.split(num_list, 2)
        [child, metadata] = extracted_data
        new_node = %Node8{child: child, metadata: metadata, child_no: child}
        updated_node = %{node | child: n - 1}
        run(tail_num_list, tail_stack ++ [updated_node, new_node], graph)
    end
  end

  defp toKey(stack) do
    stack
    |> Enum.map(fn s -> s.child_no - s.child end)
    |> Enum.join(",")
  end

  defp calculate(path, map) do
    node = map[path]

    if node == nil do
      0
    else
      if node.child_no == 0 do
        Enum.sum(node.data)
      else
        node.data
        |> Enum.map(fn m ->
          String.split(path, ",")
          |> Enum.filter(fn s -> s != "" end)
          |> Enum.concat([m])
          |> Enum.join(",")
        end)
        |> Enum.map(fn p -> calculate(p, map) end)
        |> Enum.sum()
      end
    end
  end
end

file_name = "input.txt"
# file_name = "sample.txt"

{:ok, str} = File.read(file_name)

str
|> String.split(" ")
|> Enum.map(&String.to_integer/1)
|> Logic.find()
|> IO.inspect()
