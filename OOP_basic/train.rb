class Train

  attr_reader :number, :type, :quantity_of_wagons, :speed, :train_route

  def initialize(number, type, quantity_of_wagons)
    @number = number
    @type = type
    @quantity_of_wagons = quantity_of_wagons
    @speed = 0
    @info = [number,type, quantity_of_wagons, speed]
  end

  def stop
    self.speed = 0
  end

  def speed=(speed)
    @speed = speed
    @info.delete_at(3)
    @info.insert(3, @speed)
  end

  def add_wagon
    @quantity_of_wagons += 1 if @speed == 0
  end

  def delete_wagon
    @quantity_of_wagons -= 1 if @speed == 0
  end

  def get_route(route)
    @train_route = route
    @info << route.route_number
    @station_index = 0                    # Номер станции из списка станций на маршруте
    #@train_route.route_stations[0].parking_trains(self)
  end

  def current_station
    @train_route.route_stations[@station_index]
  end

  def previos_station
    @train_route.route_stations[@station_index - 1] if @train_route && @station_index >= 1
  end

  def next_station
    @train_route.route_stations[@station_index + 1] if @train_route && @station_index < @train_route.route_stations[-1]    
  end

  def go_to_next_station
    if @train_route && @station_index < @train_route.route_stations[-1]
      @train_route.route_stations[@station_index].leaving_trains(self)
      @station_index += 1
      @train_route.route_stations[@station_index].parking_trains(self)
    end
  end

  def go_to_previos_station
    if @train_route && @station_index >= 1
      @train_route.route_stations[@station_index].leaving_trains(self)
      @station_index -= 1
      @train_route.route_stations[@station_index].parking_trains(self)
    end
  end

  def info
    puts @info
  end

end
