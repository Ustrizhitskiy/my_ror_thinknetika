class Station
  attr_reader :name, :trains

  def initialize(name)
    @name = name
    @trains = []
  end

  def parking_trains(train)
    @trains << train
  end

  def parking_trains_by_type(train_type)
    @trains.select { |train| train.type == train_type }
  end

  def leaving_trains(train)
    @trains.delete(train)
  end

end
