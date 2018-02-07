class CargoTrain < Train

  def initialize(number)
    super
    @type = :Cargo
  end

  def add_wagon(wagon)
    @wagons << wagon if @speed == 0 && wagon.type == :Cargo
  end

end
