module Validation
  def self.included(base)
    base.extend ClassMethods
    base.send :include, InstanceMethods
  end

  module ClassMethods
    attr_reader :validations

    def validate(name, *args)
      @validations ||= []
      @validations << { name => args }
    end
  end

  module InstanceMethods
    def validate!
      self.class.validations.each do |validation|
        validation.each do |name, args|
          attribute = instance_variable_get("@#{name}".to_sym)
          send(args[0], attribute, args[1])
          puts "Валидация '#{args[0]}' пройдена!"
        end
      end
    end

    def valid?
      validate!
    rescue RuntimeError
      false
    end

    protected

    def validation_presence(attribute_name, _args)
      raise "\nНе введено ни одного символа!" if
      attribute_name.to_s.empty? || attribute_name.nil? || attribute_name == 0
    end

    def validation_format(attribute_name, value)
      return unless attribute_name !~ value
      raise "\nНеправильный формат! Необходимо: ххх-хх,
        \rгде х - любая буква латинского алфавита или цифра!"
    end

    def validation_type(attribute_name, class_name)
      raise "\nПоследовательность не является строкой!" unless
        attribute_name.is_a? class_name
    end
  end
end
