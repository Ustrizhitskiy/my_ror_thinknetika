class Route
  include InstanceCounter
  include Accessor
  include Validation

  attr_reader :route_stations, :route_number, :start_station, :finish_station

  validate :route_number, :presence

  @@all_routes = []

  def initialize(route_number, start_station, finish_station)
    @route_number = route_number
    @start_station = start_station
    @finish_station = finish_station
    validate!
    additional_validation!
    @route_stations = [start_station, finish_station]
    @@all_routes << self
    register_instance
  end

  def add_in_between_station(station_name)
    @route_stations.insert(-2, station_name)
  end

  def remove_in_between_station(station_name)
    @route_stations.delete(station_name)
  end

  def all_stations_of_route
    puts "Список станций по маршруту №_#{@route_number}:"
    @route_stations.each.with_index(1) do |station, index|
      puts "#{index}. #{station.name}"
    end
  end

  protected

  def additional_validation!
    raise 'Не введен номер маршрута!' if @route_number.zero?
    raise 'Введенная станция не является экземпляром класса Station!' unless
      start_station.is_a?(Station)
    raise 'Введенная станция не является экземпляром класса Station!' unless
      finish_station.is_a?(Station)
    @@all_routes.each do |route|
      raise 'Маршрут с таким номером уже существует!' if
        route.route_number == route_number
    end
    true
  end
end
