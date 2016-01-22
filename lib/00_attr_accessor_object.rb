class AttrAccessorObject
  def self.my_attr_accessor(*names)
    # ...
    names.each do |name|
      define_method("#{name}") { instance_variable_get("@#{name}") }
      define_method("#{name}=") do |whatever|
        instance_variable_set("@#{name}", whatever)
      end
    end
  end
end
