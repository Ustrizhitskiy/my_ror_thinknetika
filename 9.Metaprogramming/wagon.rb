class Wagon
  include Manufacturer
  include InstanceCounter
  attr_reader :all_capacity, :occupied_capacity, :free_capacity

  def initialize(manufacturer, all_capacity)
    @manufacturer = manufacturer
    @all_capacity = all_capacity
    @occupied_capacity = 0
    @free_capacity = @all_capacity
    register_instance
  end
end
