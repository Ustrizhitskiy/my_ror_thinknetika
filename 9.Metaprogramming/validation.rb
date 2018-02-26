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

    def presence(attr_name, _args)
      return unless attr_name.to_s.empty? || attr_name.nil? || attr_name == 0
      raise "\nНе введено ни одного символа!"
    end

    def format(attr_name, value)
      return unless attr_name !~ value
      raise "\nНеправильный формат! Необходимо: ххх-хх,
            \rгде х - любая буква латинского алфавита или цифра!"
    end

    def type(attr_name, class_name)
      unless attr_name.is_a? class_name
        raise "\nПоследовательность не является строкой!"
      end
    end
  end
end
