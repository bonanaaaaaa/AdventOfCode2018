file = File.open('input.txt', 'r')

arr = []

maxX = -1
maxY = -1

file.each_line do |line|
  aa,a = line.split('@')
  pos, size = a.split(':')
  x, y = pos.split(',').map(&:to_i)
  lenX, lenY = size.split('x').map(&:to_i)
  maxX = [maxX, x + lenX].max
  maxY = [maxY, y + lenY].max
  arr.push({
    x1: x + 1,
    x2: x + lenX,
    y1: y + 1,
    y2: y + lenY
  })
end
file.close

puts maxX
puts maxY
# puts arr

area = 0

(1..maxX).each do |x|
  (1..maxY).each do |y|
    count = 0
    arr.each do |rec|
      if (rec[:x1] <= x and x <= rec[:x2] and rec[:y1] <= y and y <= rec[:y2]) then
        # puts "x => #{x}, y => #{y}"
        # puts "x1 => #{rec[:x1]}, x2 => #{rec[:x2]}, y1 => #{rec[:y1]}, y2 => #{rec[:y2]}"
        # puts "======================="
        count += 1
      end

      if count == 2 then
        area += 1
        break
      end
    end
  end
end

puts "Ans: #{area}"
