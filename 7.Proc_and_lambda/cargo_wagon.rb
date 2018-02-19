class CargoWagon
  #include Manufacturer
  attr_reader :number, :all_volume, :occupied_volume, :free_volume

  @@number = 0

  def initialize(manufacturer, all_volume)
    @manufacturer = manufacturer
    @all_volume = all_volume
    @occupied_volume = 0
    @free_volume = @all_volume
    @@number += 1
    @number = @@number
  end

  def take_some_volume(some_volume)
    if @free_volume > 0 && (@free_volume - some_volume) >= 0
      puts "Вы заняли #{some_volume} единиц объема."
      @occupied_volume += some_volume
      @free_volume -= some_volume
      puts "Свободного объема осталось #{@free_volume} единиц."
    else
      puts "Свободного объема осталось #{@free_volume}."
    end
  end

end
