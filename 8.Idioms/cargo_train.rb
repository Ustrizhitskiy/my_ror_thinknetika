class CargoTrain < Train
  private

  def right_type?(wagon)
    wagon.is_a? CargoWagon
  end
end
