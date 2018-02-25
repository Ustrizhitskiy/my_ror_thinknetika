class Station
  include InstanceCounter
  include Validation

  attr_reader :name, :trains

  validate :name, :validation_presence

  @@all_instances = []

  def self.all_instances
    @@all_instances
  end

  def initialize(name)
    @name = name
    validate!
    additional_validation!
    @trains = []
    register_instance
    @@all_instances << self
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

  def each_train_on_station
    if block_given? @trains.each.with_index(1) do |train, index|
      yield(train, index)
    end
    end
  end

  private

  def additional_validation!
    raise 'Станция с таким именем уже существует!' unless
      @@all_instances.select { |station| station.name == @name }.empty?
    true
  end
end
