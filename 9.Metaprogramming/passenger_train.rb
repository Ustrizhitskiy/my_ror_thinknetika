class PassengerTrain < Train
  validate :number, :validation_presence
  validate :number, :validation_format, NUMBER_FORMAT
  validate :number, :validation_type, String

  private

  def right_type?(wagon)
    wagon.is_a? PassengerWagon
  end
end
