file = File.open('input.txt', 'r')

arr = []

file.each_line do |line|
  aa, a = line.split('@')
  pos, size = a.split(':')
  x, y = pos.split(',').map(&:to_i)
  lenX, lenY = size.split('x').map(&:to_i)
  arr.push({
    x1: x + 1,
    x2: x + lenX,
    y1: y + 1,
    y2: y + lenY,
  })
end
file.close

$mem = {}

def intersect_area(rec1, rec2)
  area = 0
  (rec1[:x1]..rec1[:x2]).each do |x|
    (rec1[:y1]..rec1[:y2]).each do |y|
      if (rec2[:x1] <= x and x <= rec2[:x2] and rec2[:y1] <= y and y <= rec2[:y2]) then
        if (!$mem.has_key?("#{x},#{y}")) then
          area += 1
        end
        $mem["#{x},#{y}"] = true
      end
    end
  end
  area
end

ans = 0

(0...arr.size).each do |i|
  (i+1...arr.size).each do |j|
    ans += intersect_area(arr[i], arr[j])
  end
end

puts "Ans: #{ans}"
