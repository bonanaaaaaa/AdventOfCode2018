File.open('input.txt', 'r') do |f|
  sum = 0
  f.each_line do |line|
    sum += line.to_i
  end

  puts sum
end