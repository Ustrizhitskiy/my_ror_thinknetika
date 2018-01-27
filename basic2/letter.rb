arr_vowel = %w(a e i o u y)
arr_alphabet = ('a'..'z').to_a
hash_vowel = {}

arr_alphabet.each_with_index do |key, index|
  hash_vowel[key] = index + 1 if arr_vowel.include?(key)
end
puts hash_vowel

hash_vowel.each do |letter, index|
  puts "#{letter} - #{index}-я буква латинского алфавита"
end
