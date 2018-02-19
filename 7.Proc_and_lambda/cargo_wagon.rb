class CargoWagon < Wagon
  def take_some_volume(some_volume)
    if @free_capacity > 0 && (@free_capacity - some_volume) >= 0
      puts "Вы заняли #{some_volume} единиц объема."
      @occupied_capacity += some_volume
      @free_capacity -= some_volume
      puts "Свободного объема осталось #{@free_capacity} единиц."
    else
      puts "Свободного объема осталось #{@free_capacity}."
    end
  end
end
