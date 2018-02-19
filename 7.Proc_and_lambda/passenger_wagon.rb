class PassengerWagon
  #include Manufacturer
  attr_reader :number, :all_seats, :occupied_seats, :free_seats

  @@number = 0

  def initialize(manufacturer, all_seats)
    @manufacturer = manufacturer
    @all_seats = all_seats
    @occupied_seats = 0
    @free_seats = @all_seats
    @@number += 1
    @number = @@number
  end

  def take_a_seat
    if @free_seats > 0
      @occupied_seats += 1
      @free_seats -= 1
      puts "Вы заняли место. Осталось свободных: #{@free_seats}."
    else
      puts 'Все места заняты!'
    end
  end

end
