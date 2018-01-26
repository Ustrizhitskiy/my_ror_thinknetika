total_sum = 0

hash_product_cost_quantity = {}       # Хэш для общей стоимости одного продукта
hash_cost_quantity = {}               # Хэш для записи стоимости и количества каждого продукта
hash_products = {}                    # Хэш для всех покупок

loop do
  print "Введите товар, который желаете приобрести: "
  product = gets.chomp.to_s
  break if product == 'стоп'
  print "По какой цене хотели бы приобрести: "
  cost = gets.chomp.to_f
  print "Сколько товара желаете приобрести: "
  quantity = gets.chomp.to_f

  total_sum += cost * quantity

  hash_product_cost_quantity[product] = cost * quantity
  hash_cost_quantity[cost] = quantity
  hash_products[product] = hash_cost_quantity
  hash_cost_quantity = {}
end

puts hash_products
puts hash_product_cost_quantity
puts "Ваши покупки:"
hash_product_cost_quantity.each do | product, quantity |
  puts "Вы купили #{product} на #{quantity} рублей."
end
puts "Ваши покупки в корзине на сумму: #{total_sum} рублей."
