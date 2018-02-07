class PassengerTrain < Train

  def initialize(number)
    super
    @type = :Passenger
  end

  def add_wagon(wagon)
    @wagons << wagon if @speed == 0 && wagon.type == :Passenger
  end

end
