class PassengerTrain < Train
  validate :number, :presence
  validate :number, :format, NUMBER_FORMAT
  validate :number, :type, String

  private

  def right_type?(wagon)
    wagon.is_a? PassengerWagon
  end
end
