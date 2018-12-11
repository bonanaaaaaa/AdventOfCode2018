defmodule Logic do
  def find(pos_list) do
    Enum.reduce(
      0..20000,
      %{
        sec: -1,
        min: 99_999_999
      },
      fn sec, m ->
        pos_list_at_sec =
          pos_list
          |> Enum.map(fn pos -> pos_at_sec(pos, sec) end)

        pos_map =
          pos_list_at_sec
          |> Enum.reduce(%{}, fn pos, m -> Map.put(m, "#{pos.x},#{pos.y}", false) end)

        connected_count = count_connected(pos_map, 0)

        if connected_count < m.min do
          %{
            sec: sec,
            min: connected_count
          }
        else
          m
        end
      end
    )
  end

  def print(pos_list, sec) do
    pos_list_at_sec =
      pos_list
      |> Enum.map(fn pos -> pos_at_sec(pos, sec) end)

    frame = get_frame(pos_list_at_sec)
    IO.inspect(frame)
    [min_x, max_x, min_y, max_y] = frame

    pos_map =
      pos_list_at_sec
      |> Enum.reduce(%{}, fn pos, m -> Map.put(m, "#{pos.x},#{pos.y}", "#") end)

    out_file = "out.txt"

    {:ok, file} = File.open(out_file, [:write])

    for y <- min_y..max_y do
      str =
        min_x..max_x
        |> Enum.reduce("", fn x, str -> str <> Map.get(pos_map, "#{x},#{y}", ".") end)

      IO.write(file, str <> "\n")
    end

    File.close(out_file)
  end

  defp count_connected(pos_map, count) do
    is_done =
      pos_map |> Map.keys() |> Enum.reduce(true, fn k, acc -> acc && Map.get(pos_map, k) end)

    if is_done do
      count
    else
      [x, y] =
        pos_map
        |> Map.keys()
        |> Enum.find(fn k -> Map.get(pos_map, k) == false end)
        |> String.split(",")
        |> Enum.map(&String.to_integer/1)

      new_pos_map = cc(%{x: x, y: y}, Map.put(pos_map, "#{x},#{y}", true))
      count_connected(new_pos_map, count + 1)
    end
  end

  def cc(pos, pos_map) do
    keys = [
      "#{pos.x - 1},#{pos.y}",
      "#{pos.x + 1},#{pos.y}",
      "#{pos.x},#{pos.y - 1}",
      "#{pos.x},#{pos.y + 1}"
    ]

    filtered_keys =
      keys
      |> Enum.filter(fn k -> Map.get(pos_map, k) == false end)

    is_done = Enum.count(filtered_keys) == 0

    if is_done do
      pos_map
    else
      filtered_keys
      |> Enum.reduce(pos_map, fn k, m ->
        [x, y] = String.split(k, ",") |> Enum.map(&String.to_integer/1)
        cc(%{x: x, y: y}, Map.put(m, k, true))
      end)
    end
  end

  def get_frame(pos_list) do
    Enum.reduce(
      pos_list,
      [
        999_999,
        -999_999,
        999_999,
        -999_999
      ],
      fn pos, [min_x, max_x, min_y, max_y] ->
        [
          Enum.min([min_x, pos.x]),
          Enum.max([max_x, pos.x]),
          Enum.min([min_y, pos.y]),
          Enum.max([max_y, pos.y])
        ]
      end
    )
  end

  def pos_at_sec(pos, sec) do
    %{x: pos.x + pos.vx * sec, y: pos.y + pos.vy * sec}
  end
end

input_regex =
  ~r/position=<\s*(?<x>[\d-]+),\s*(?<y>[\d-]+)> velocity=<\s*(?<vx>[\d-]+),\s*(?<vy>[\d-]+)>/

file_name = "input.txt"
# file_name = "sample.txt"

pos_list =
  File.stream!(file_name)
  |> Stream.map(&String.trim/1)
  |> Enum.map(&Regex.named_captures(input_regex, &1))
  |> Enum.map(
    &%{
      x: div(String.to_integer(&1["x"]), 1),
      y: div(String.to_integer(&1["y"]), 1),
      vx: String.to_integer(&1["vx"]),
      vy: String.to_integer(&1["vy"])
    }
  )

ans = Logic.find(pos_list)
Logic.print(pos_list, ans.sec)
