class Train

  attr_reader :number, :type, :route, :wagons
  attr_writer :speed

  def initialize(number)
    @number = number
    @wagons = []
    @speed = 0
  end

  def stop
    self.speed = 0
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
