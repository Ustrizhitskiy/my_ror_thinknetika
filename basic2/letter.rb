arr_vowel = [ 'a', 'e', 'i', 'o', 'u', 'y' ]
arr_alphabet = ('a'..'z').to_a
hash_vowel = {}

n = 0

while n < 26
  key = arr_alphabet[n]
  if arr_vowel.include?(key)
    hash_vowel[key] = n + 1
    puts "#{key} - #{n + 1}-я буква латинского алфавита"
  end
  n += 1
end

puts hash_vowel
