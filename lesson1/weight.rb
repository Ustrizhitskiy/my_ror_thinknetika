print "Введите Ваш имя: "
your_name = gets.chomp
if (your_name.length < 1)
	print "Имя должно состоять хотя бы из одного символа. Попробуйте еще: "
	your_name = gets.chomp
end

print "Введите Ваш рост в см: "
growth = gets.chomp.to_i
if (growth < 1)
	puts "Рост есть у каждого :) Попробуйте ввести снова: "
	growth = gets.chomp.to_i
elsif (growth > 1 && growth <= 30)
	puts "У Вас не может быть такой рост :) Попробуйте ввести снова: "
	growth = gets.chomp.to_i
end

perfect_weight = growth - 110
if (perfect_weight < 0)
	puts "#{your_name}, Ваш вес уже оптимальный"
else 
	puts "#{your_name}, Ваш идеальный вес #{perfect_weight}"
end
