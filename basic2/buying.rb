total_sum = 0

hash_products = {}                    # Хэш для всех покупок

loop do
  print 'Введите товар, который желаете приобрести: '
  product = gets.chomp.to_s
  break if product == 'стоп'
  print 'По какой цене хотели бы приобрести: '
  cost = gets.chomp.to_f
  print 'Сколько товара желаете приобрести: '
  quantity = gets.chomp.to_f

  total_one_product = cost * quantity

  total_sum += total_one_product

  hash_products[product] = {cost: cost, quantity: quantity, total_one_product: total_one_product}
end

puts hash_products
puts 'Ваши покупки:'
hash_products.each do |product, all_quality|
  puts "Вы купили #{product} на #{all_quality[:total_one_product]} рублей."
end
puts "Ваши покупки в корзине на сумму: #{total_sum} рублей."
