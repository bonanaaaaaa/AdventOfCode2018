defmodule Logic do
  def run(arr, current_marble_index, counter, scores, current_player) do
    # IO.inspect(counter)
    # IO.inspect(arr)
    # IO.inspect(current_marble_index)
    # IO.inspect(Enum.at(arr, current_marble_index))
    # IO.puts("===============")
    # players = 9
    # last_marble = 50
    players = 10
    last_marble = 1618

    # players = 30
    # last_marble = 5807

    # players = 13
    # last_marble = 7999

    # players = 413
    # last_marble = 71082

    cond do
      counter == 0 ->
        run([0, 1], 1, 1, %{}, 0)

      counter == last_marble ->
        scores

      rem(counter, 23) == 22 ->
        # {sliced, remain} = split_counter_cw(arr, current_marble_index, 7)
        {pop_score, remain} =
          List.pop_at(arr, find_ccw_pos(Enum.count(arr), current_marble_index, 7))

        score = counter + pop_score + 1

        new_current_marble_index =
          if current_marble_index < 7 do
            Enum.count(arr) + (current_marble_index - 7)
          else
            current_marble_index - 7
          end

        new_scores = Map.update(scores, current_player, score, &(&1 + score))

        run(
          remain,
          new_current_marble_index,
          counter + 1,
          new_scores,
          rem(current_player + 1, players)
        )

      true ->
        next_1 =
          if current_marble_index + 1 >= Enum.count(arr) do
            0
          else
            current_marble_index + 1
          end

        new_counter = counter + 1

        new_current_marble_index = next_1 + 1

        {head, tail} = Enum.split(arr, next_1 + 1)
        new_arr = head ++ [new_counter] ++ tail

        run(
          new_arr,
          new_current_marble_index,
          new_counter,
          scores,
          rem(current_player + 1, players)
        )
    end
  end

  defp find_ccw_pos(arr_count, index, step) do
    if index < step do
      arr_count + (index - step)
    else
      index - step
    end
  end

  # defp split_counter_cw(arr, start_index, amount) do
  #   if start_index < amount do
  #     {head, tail} = Enum.split(arr, start_index)
  #     {head2, tail2} = Enum.split(tail, start_index - amount)

  #     {head ++ tail2, head2}
  #   else
  #     {head, tail} = Enum.split(arr, start_index - amount)
  #     {head2, tail2} = Enum.split(tail, amount)

  #     {head2, head ++ tail2}
  #   end
  # end
end

Logic.run([0], 0, 0, %{}, 0) |> IO.inspect() |> Map.values() |> Enum.max() |> IO.inspect()
