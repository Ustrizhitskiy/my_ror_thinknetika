module Accessor
  def self.included(base)
    base.extend ClassMethods
  end

  module ClassMethods
    def attr_accessor_with_history(*names)
      names.each do |name|
        var_name = "@#{name}".to_sym
        define_method(name) { instance_variable_get(var_name) }
        define_method("#{name}=".to_sym) do |value|
          instance_variable_set(var_name, value)
          values ||= []
          values << instance_variable_get(var_name)
        end
      end
      define_method("#{name}_history".to_sym) { values }
    end

    def strong_attr_accessor(name, class_name)
      var_name = "@#{name}".to_sym
      define_method(name) { instance_variable_get(var_name) }
      define_method("#{name}=".to_sym) do |value|
        raise 'Значение не может быть присвоено!' unless value.is_a? class_name
        instance_variable_set(var_name, value)
      end
    end
  end
end
