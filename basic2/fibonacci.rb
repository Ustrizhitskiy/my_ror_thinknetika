arr = [0, 1]
i = 1

until arr[i] + arr[i-1]> 100
  i += 1
  arr[i] = arr[i-1] + arr[i-2]
end

puts arr.to_s
