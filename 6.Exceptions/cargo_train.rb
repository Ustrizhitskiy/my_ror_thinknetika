class CargoTrain < Train

  private     # чтобы можно было вызвать только внутри класса CargoTrain

  def is_right_type?(wagon)
    wagon.is_a?CargoWagon
  end

end
