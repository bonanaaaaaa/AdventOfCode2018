defmodule Logic do
  def find(state, transform_map) do
    head = ".."

    1..500
    |> Enum.reduce(state, fn _g, st ->
      new_state = head <> st
      # IO.puts(st)
      cal(new_state, transform_map)
    end)
    # |> IO.inspect()
    |> sum()
  end

  def sum(state) do
    state
    |> String.graphemes()
    |> Enum.reduce(
      %{
        sum: 0,
        count: -3
      },
      fn s, data ->
        if s == "#" do
          new_sum = data.sum + data.count
          new_count = data.count + 1

          %{
            count: new_count,
            sum: new_sum
          }
        else
          %{
            count: data.count + 1,
            sum: data.sum
          }
        end
      end
    )
  end

  def cal(state, map) do
    # IO.puts(state)

    if state == "....." do
      "."
    else
      if String.length(state) < 5 do
        cal(state <> ".", map)
      else
        pattern = String.slice(state, 0..4)

        # if Map.has_key?(map, pattern) do
        #   IO.puts(pattern)
        # end

        # IO.puts(Map.has_key?(map, pattern))
        # mid = String.at(pattern, 2)

        new_mid = Map.get(map, pattern, ".")
        new_mid <> cal(String.slice(state, 1..-1), map)
      end
    end
  end
end

initialState =
  "..." <>
    "##.######...#.##.#...#...##.####..###.#.##.#.##...##..#...##.#..##....##...........#.#.#..###.#"

map = %{
  ".###.": "#",
  "#.##.": ".",
  ".#.##": "#",
  "...##": ".",
  "###.#": "#",
  "##.##": ".",
  ".....": ".",
  "#..#.": "#",
  "..#..": "#",
  "#.###": "#",
  "##.#.": ".",
  "..#.#": "#",
  "#.#.#": "#",
  ".##.#": "#",
  ".#..#": "#",
  "#..##": "#",
  "##..#": "#",
  "#...#": ".",
  "...#.": "#",
  "#####": ".",
  "###..": "#",
  "#.#..": ".",
  "....#": ".",
  ".####": "#",
  "..###": ".",
  "..##.": "#",
  ".##..": ".",
  "#....": ".",
  "####.": "#",
  ".#.#.": ".",
  ".#...": "#",
  "##...": "#"
}

# initialState = "..." <> "#..#.#..##......###...###"

# map = %{
#   "...##": "#",
#   "..#..": "#",
#   ".#...": "#",
#   ".#.#.": "#",
#   ".#.##": "#",
#   ".##..": "#",
#   ".####": "#",
#   "#.#.#": "#",
#   "#.###": "#",
#   "##.#.": "#",
#   "##.##": "#",
#   "###..": "#",
#   "###.#": "#",
#   "####.": "#"
# }

str_key_map =
  map
  |> Map.keys()
  |> Enum.reduce(%{}, fn k, m ->
    k_str = Atom.to_string(k)
    Map.put(m, k_str, Map.get(map, k))
  end)

# IO.inspect(str_key_map)

Logic.find(initialState, str_key_map)
|> IO.inspect()
