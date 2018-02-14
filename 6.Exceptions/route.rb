class Route
  include InstanceCounter
  include Validation

  attr_reader :route_stations, :route_number

  @@all_routes = []

  def initialize(route_number, start_station, finish_station)
    @route_number = route_number
    @route_stations = [start_station, finish_station]
    validate!
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
    @route_stations.each.with_index(1) { |station, index| puts "#{index}. #{station.name}"}
  end

  protected

  def validate!
    raise 'Не введен номер маршрута!' if @route_number == 0
    raise 'Не назначена начальная станция!' if @route_stations[0].empty?
    raise 'Не назначена начальная станция!' if @route_stations[-1].empty?
    raise 'Такой маршрут уже существует!' if @@all_routes.select{ |route| route.number == @number }.size != 0 
  end

end
