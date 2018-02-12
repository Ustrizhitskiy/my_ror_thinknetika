class Train
  include Manufacturer
  include InstanceCounter

  attr_reader :number, :route, :wagons
  attr_writer :speed

  @@all_trains_objects = {}

  def self.all_trains_objects
    @@all_trains_objects
  end

  def self.find_train(number)
    @@all_trains_objects[number]
  end

  def self.about_train(number)
    value = @@all_trains_objects[number]
    puts "#{value.number} | #{value.class} | #{value.wagons.size} вагонов."
  end

  def initialize(number, manufacturer)
    @number = number
    @manufacturer = manufacturer
    @wagons = []
    @speed = 0
    @@all_trains_objects[@number] = self
    register_instance
  end

  def stop
    self.speed = 0
  end

  def add_wagon(wagon)
    @wagons << wagon if @speed == 0 && is_right_type?(wagon)
  end

  def delete_wagon
    @wagons.delete_at(-1) if @speed == 0 && @wagons.size >= 1
  end

  def set_route(route)
    @route = route
    @station_index = 0
    current_station.parking_trains(self)
  end

  def current_station
    @route.route_stations[@station_index]
  end

  def previos_station
    @route.route_stations[@station_index - 1] if @route && @station_index >= 1
  end

  def next_station
    @route.route_stations[@station_index + 1] if @route && @station_index < (@route.route_stations.size - 1)
  end

  def go_to_next_station
    if @route && @station_index < (@route.route_stations.size - 1)
      @route.route_stations[@station_index].leaving_trains(self)
      @station_index += 1
      @route.route_stations[@station_index].parking_trains(self)
    end
  end

  def go_to_previos_station
    if @route && @station_index >= 1
      @route.route_stations[@station_index].leaving_trains(self)
      @station_index -= 1
      @route.route_stations[@station_index].parking_trains(self)
    end
  end

end
