f = File.open('input.txt', 'r')

arr = []

f.each_line do |line|
  arr << line.to_i
end
f.close

sum = 0
i = 0
mem = {}

loop do
  num = arr[i]
  if mem[sum]
    puts sum
    break
  else
    mem[sum] = true
    sum += num
    i = i + 1 == arr.size ? 0 : i + 1
  end
end
