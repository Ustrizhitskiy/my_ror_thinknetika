module Accessor
  def self.included(base)
    base.extend ClassMethods
  end

  module ClassMethods
    def attr_accessor_with_history(*names)
      names.each do |name|
        var_name = "@#{name}".to_sym
        define_method(name) { instance_variable_get(var_name) }
        define_method("#{name}_history".to_sym) do
          instance_variable_get("@#{name}_history")
        end
        define_method("#{name}=".to_sym) do |value|
          values = instance_variable_get("@#{name}_history") || []
          values << value
          instance_variable_set("@#{name}_history", values)
          instance_variable_set("@#{name}", value)
        end
      end
    end

    def strong_attr_accessor(name, class_name)
      var_name = "@#{name}".to_sym
      define_method(name) { instance_variable_get(var_name) }
      define_method("#{name}=".to_sym) do |value|
        raise 'Тип должен быть Integer!' unless value.is_a? class_name
        instance_variable_set(var_name, value)
      end
    end
  end
end
