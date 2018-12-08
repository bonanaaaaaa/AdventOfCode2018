defmodule Node8 do
  defstruct [:child, :metadata]
end

defmodule Logic do
  def find(num_list) do
    stack = []
    {extracted_data, tail_num_list} = Enum.split(num_list, 2)
    [child, metadata] = extracted_data
    stack = stack ++ [%Node8{child: child, metadata: metadata}]

    run(tail_num_list, stack)
  end

  defp run(num_list, stack, sum \\ 0)

  defp run([], [], sum), do: sum

  defp run(num_list, stack, sum) do
    {node, tail_stack} = List.pop_at(stack, -1)

    case node.child do
      0 ->
        {metadata_list, tail_num_list} = Enum.split(num_list, node.metadata)
        run(tail_num_list, tail_stack, sum + Enum.sum(metadata_list))

      n ->
        {extracted_data, tail_num_list} = Enum.split(num_list, 2)
        [child, metadata] = extracted_data
        new_node = %Node8{child: child, metadata: metadata}
        new_child = n - 1
        updated_node = %{node | child: new_child}
        run(tail_num_list, tail_stack ++ [updated_node, new_node], sum)
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
