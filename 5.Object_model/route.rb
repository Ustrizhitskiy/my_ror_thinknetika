class Route
  include InstanceCounter

  attr_reader :route_stations, :route_number

  def initialize(route_number, start_station, finish_station)
    @route_number = route_number
    @route_stations = [start_station, finish_station]
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

end
