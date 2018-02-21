class PassengerTrain < Train
  private

  def right_type?(wagon)
    wagon.is_a? PassengerWagon
  end
end
