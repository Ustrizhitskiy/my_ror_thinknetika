class Train
  include Manufacturer
  include InstanceCounter
  include Validation

  attr_reader :number, :route, :wagons
  attr_writer :speed

  NUMBER_FORMAT = /^[a-z0-9]{3}-*[a-z0-9]{2}$/i

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
    validate!
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

  def each_wagon_in_train(&block)
    @wagons.each.with_index(1) { |wagon, index| yield(wagon, index) } if block_given?
  end

  protected

  def validate!
    raise "\nНе введено ни одного символа в номере поезда!" if @number.empty?
    raise "\nНе введен производитель!" if @manufacturer.empty?
    raise "\nНеправильный формат номера. Необходимо: ххх-хх, где х - любая буква латинского алфавита или цифра." if 
      @number !~ NUMBER_FORMAT
    raise "\nПоезд с таким номером уже существует!" if @@all_trains_objects.include? @number

    true
  end

end
