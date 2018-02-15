class PassengerTrain < Train

  private     # чтобы можно было вызвать только внутри класса PassengerTrain

  def is_right_type?(wagon)
    wagon.is_a? PassengerWagon
  end

end
