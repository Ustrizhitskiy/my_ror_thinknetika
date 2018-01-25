puts "Введите коэффициенты."

print "a = "
a = gets.to_f

print " b= "
b = gets.to_f

print " c= "
c = gets.to_f

if ( b < 0 )
	if ( c < 0 )
		puts "Ваше уравнение имеет вид: #{a}x^2 - #{b - 2 * b}x - #{c - 2 * c} = 0"
	elsif
		puts "Ваше уравнение имеет вид: #{a}x^2 - #{b - 2 * b}x + #{c} = 0"
	end
elsif
	if ( c < 0 )
		puts "Ваше уравнение имеет вид: #{a}x^2 + #{b}x - #{c - 2 * c} = 0"
	elsif
		puts "Ваше уравнение имеет вид: #{a}x^2 + #{b}x + #{c} = 0"
	end
end

d = b ** 2 - 4 * a * c
if ( a != 0 )
	if ( d >= 0 )
		x1 = ( - b - Math.sqrt( d )) / ( 2 * a )
		x2 = ( - b + Math.sqrt( d )) / ( 2 * a )
			if ( x1 == x2 )
				puts "Уравнение имеет один корень (два одинаковых):"
				puts "x=#{x1}"
			else
				puts "Корни уравнения: "
				puts "х1=#{x1}"
				puts "x2=#{x2}"
			end
	else
		puts "Уравнение не имеет корней"
	end
else
	puts "Это не квадратное уравнение, а не может быть равным 0!"
end
