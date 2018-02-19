class Station
  include InstanceCounter
  include Validation

  attr_reader :name, :trains

  @@all_instances = []

  def self.all_instances
    @@all_instances
  end

  def initialize(name)
    @name = name
    validate!
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
    @trains.each.with_index(1) { |train, index| yield(train, index) } if block_given?
  end

  private

  def validate!
    raise 'Не введено ни одного символа!' if @name.empty?
    raise "Станция с таким именем уже существует!" if
      @@all_instances.select { |station| station.name == @name }.size != 0
      
    true
  end
end
