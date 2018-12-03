# file = File.open('input.txt', 'r')
file = File.open('sample.txt', 'r')

arr = []

file.each_line do |line|
  id, a = line.split('@')
  pos, size = a.split(':')
  x, y = pos.split(',').map(&:to_i)
  lenX, lenY = size.split('x').map(&:to_i)
  arr.push({
    id: id,
    x1: x + 1,
    x2: x + lenX,
    y1: y + 1,
    y2: y + lenY
  })
end
file.close

def intersect(rec1, rec2)
  (rec1[:x1]..rec1[:x2]).each do |x|
    (rec1[:y1]..rec1[:y2]).each do |y|
      if (rec2[:x1] <= x and x <= rec2[:x2] and rec2[:y1] <= y and y <= rec2[:y2]) then
        return true
      end
    end
  end
  return false
end

mem = {}

for i in 0...arr.size
  mem[i] = false
end

for i in 0...arr.size
  if mem[i] == true then
    next
  end
  for j in 0...arr.size
    if i == j then
      next
    end
    if (intersect(arr[i], arr[j])) then
      mem[i] = true
      mem[j] = true
    end
  end
end

# puts ans.size
mem.each_key do |key|
  if mem[key] == false then
    puts arr[key]
  end
end
