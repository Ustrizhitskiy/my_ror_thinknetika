puts 'Введите коэффициенты.'

print 'a = '
a = gets.to_f

print ' b= '
b = gets.to_f

print ' c= '
c = gets.to_f

if ( b < 0 && c < 0 )
  puts "Ваше уравнение имеет вид: #{a}x^2 - #{b.abs}x - #{c.abs} = 0"
elsif ( b < 0 && c > 0 )
  puts "Ваше уравнение имеет вид: #{a}x^2 - #{b.abs}x + #{c} = 0"
end

if ( b >= 0 && c < 0 )
  puts "Ваше уравнение имеет вид: #{a}x^2 + #{b}x - #{c.abs} = 0"
elsif ( c > 0 )
  puts "Ваше уравнение имеет вид: #{a}x^2 + #{b}x + #{c} = 0"
end

d = b ** 2 - 4 * a * c
if ( d > 0 )
  sqr = Math.sqrt(d)
end

if ( a != 0 && d > 0)
  x1 = ( - b - sqr) / ( 2 * a )
  x2 = ( - b + sqr) / ( 2 * a )
  puts 'Корни уравнения: '
  puts "х1=#{x1}"
  puts "x2=#{x2}"
elsif ( a != 0 && d == 0 )
  x1 = - b / ( 2 * a )
  puts 'Уравнение имеет один корень (два одинаковых):'
  puts "x=#{x1}"
end

if ( a == 0 && d >= 0 )
  puts 'Это не квадратное уравнение, а не может быть равным 0!'
elsif ( a != 0 && d < 0 )
  puts 'Уравнение не имеет корней'
end
