class Station
  attr_reader :name, :trains

  def initialize(name)
    @name = name
    @trains = []
  end

  def parking_trains(train)
    @trains << train
  end

  def parking_trains_by_type(train_class)
    @trains.select { |train| train.class == train_class }
  end

  def leaving_trains(train)
    @trains.delete(train)
  end

  def show_trains_on_station
    @trains.each.with_index(1) { |train, index|
      puts "#{index}. Номер (название): #{train.number}; тип: #{train.class}, вагонов: #{train.wagons.size}" }
  end

end
