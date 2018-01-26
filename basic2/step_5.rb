arr = []
x = 10
i = 0

loop do
  arr[i] = x
  i += 1
  x += 5
  break if x > 100
end

puts arr
