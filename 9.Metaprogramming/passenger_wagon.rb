class PassengerWagon < Wagon
  def take_a_seat
    if @free_capacity > 0
      @occupied_capacity += 1
      @free_capacity -= 1
      puts "Вы заняли место. Осталось свободных: #{@free_capacity}."
    else
      puts 'Все места заняты!'
    end
  end
end
