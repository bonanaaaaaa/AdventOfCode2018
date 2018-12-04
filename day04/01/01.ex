input_regex =
  ~r/\[(?<year>\d+)-(?<month>\d+)-(?<day>\d+)\s(?<hour>\d+):(?<minute>\d+)\]\s(?<event>[A-z#0-9\s]+)/

sorted_events =
  File.stream!("input.txt")
  |> Stream.map(&String.trim/1)
  |> Enum.map(&Regex.named_captures(input_regex, &1))
  |> Enum.map(
    &%{
      datetime:
        NaiveDateTime.new(
          String.to_integer(&1["year"]),
          String.to_integer(&1["month"]),
          String.to_integer(&1["day"]),
          String.to_integer(&1["hour"]),
          String.to_integer(&1["minute"]),
          0
        )
        |> Tuple.to_list()
        |> List.last()
        |> DateTime.from_naive("Etc/UTC")
        |> Tuple.to_list()
        |> List.last(),
      event: &1["event"]
    }
  )
  |> Enum.sort_by(fn d ->
    {d.datetime.year, d.datetime.month, d.datetime.day, d.datetime.hour, d.datetime.minute}
  end)
  |> IO.inspect()

guard_id_regex = ~r/[A-z\s]+#(?<id>\d+)[A-z\s]+/

ans =
  sorted_events
  |> Enum.reduce(
    %{
      guards: %{}
    },
    fn event, m ->
      # IO.inspect(m)

      cond do
        Regex.match?(guard_id_regex, event.event) ->
          id = Regex.named_captures(guard_id_regex, event.event) |> Map.get("id")

          new_m =
            if !Map.has_key?(m.guards, id) do
              Map.put(m, :guards, Map.put(m.guards, id, %{}))
            else
              m
            end

          Map.put(new_m, :current_id, id)

        event.event == "falls asleep" ->
          Map.put(m, :time_before, event.datetime)

        event.event == "wakes up" ->
          diff = Float.floor(DateTime.diff(event.datetime, m.time_before) / 60) |> Kernel.trunc()

          diff = diff - 1

          # IO.puts("#{m.current_id} => #{diff}")

          m1 = m.time_before.minute

          m2 =
            if event.datetime.minute == 0 do
              59
            else
              event.datetime.minute - 1
            end

          diff_m = m2 - m1

          if diff != diff_m do
            diff_m2 = m2
            diff_m1 = 60 - m1

            core = diff - diff_m2 - diff_m1
            round = Float.floor(core / 60) |> Kernel.trunc()

            guards_map =
              Enum.reduce(
                [
                  Enum.reduce(0..59, %{}, fn m, mm ->
                    Map.put(mm, m, round)
                  end),
                  Enum.reduce(m1..59, %{}, fn m, mm ->
                    Map.put(mm, m, 1)
                  end),
                  Enum.reduce(0..m2, %{}, fn m, mm ->
                    Map.put(mm, m, 1)
                  end)
                ],
                Map.get(m.guards, m.current_id),
                fn m, acc -> Map.merge(m, acc, fn _k, v1, v2 -> v1 + v2 end) end
              )

            # IO.inspect(guards_map)

            Map.put(m, :guards, Map.put(m.guards, m.current_id, guards_map))
          else
            guards_map =
              Enum.reduce(m1..m2, Map.get(m.guards, m.current_id), fn m, mm ->
                Map.update(mm, m, 1, &(&1 + 1))
              end)

            Map.put(m, :guards, Map.put(m.guards, m.current_id, guards_map))
          end
      end
    end
  )

# IO.inspect(ans.guards)

sum_map =
  Enum.reduce(Map.keys(ans.guards), %{}, fn gk, acc ->
    current_guard_map = Map.get(ans.guards, gk)

    minute =
      current_guard_map
      |> Map.keys()
      |> Enum.reduce(0, fn mk, sum -> sum + Map.get(current_guard_map, mk) end)

    Map.update(acc, gk, minute, &(&1 + minute))
  end)

IO.inspect(sum_map)

{id, _min} = Map.to_list(sum_map) |> Enum.max_by(fn {_k, v} -> v end) |> IO.inspect()

{minute, _value} =
  Map.get(ans.guards, id) |> Map.to_list() |> Enum.max_by(fn {_k, v} -> v end) |> IO.inspect()

IO.puts(String.to_integer(id) * minute)

# IO.inspect(ans.minutes)
