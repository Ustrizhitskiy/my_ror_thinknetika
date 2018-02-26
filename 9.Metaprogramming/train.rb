class Train
  include Manufacturer
  include InstanceCounter
  include Validation
  include Accessor

  NUMBER_FORMAT = /^[a-z0-9]{3}-*[a-z0-9]{2}$/i

  attr_reader :number, :route, :wagons
  attr_writer :speed
  attr_accessor_with_history :example1, :example2
  strong_attr_accessor :example, Integer

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
    additional_validation!
    @wagons = []
    @speed = 0
    @@all_trains_objects[@number] = self
    register_instance
  end

  def stop
    self.speed = 0
  end

  def add_wagon(wagon)
    @wagons << wagon if @speed.zero? && right_type?(wagon)
  end

  def delete_wagon
    @wagons.delete_at(-1) if @speed.zero? && @wagons.size >= 1
  end

  def appoint_route(route)
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
    @route.route_stations[@station_index + 1] if
      @route && @station_index < (@route.route_stations.size - 1)
  end

  def go_to_next_station
    return unless @route && @station_index < (@route.route_stations.size - 1)
    @route.route_stations[@station_index].leaving_trains(self)
    @station_index += 1
    @route.route_stations[@station_index].parking_trains(self)
  end

  def go_to_previos_station
    return unless @route && @station_index >= 1
    @route.route_stations[@station_index].leaving_trains(self)
    @station_index -= 1
    @route.route_stations[@station_index].parking_trains(self)
  end

  def each_wagon_in_train
    return unless block_given?
    @wagons.each.with_index(1) { |wagon, index| yield(wagon, index) }
  end

  protected

  def additional_validation!
    raise "\nНе введен производитель!" if @manufacturer.empty?
    raise "\nПоезд с таким номером уже существует!" if
      @@all_trains_objects.include? @number
    true
  end
end
