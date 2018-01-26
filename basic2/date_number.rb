print "Введите число месяца: "
number = gets.chomp.to_i

print "Введите номер месяца: "
month = gets.chomp.to_i

print "Введите год: "
year = gets.chomp.to_i

all_days = [31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31]

if ( year % 4 == 0 && year % 100 != 0 ) || year % 400 == 0
  all_days[1] = 29
end

i = 0
date_number = number
while i < month - 1 do
  date_number += all_days[i]
  i += 1
end

puts "Номер даты с начала года: #{date_number}"
