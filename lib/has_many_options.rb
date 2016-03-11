require_relative 'association_options'

class HasManyOptions < AssociationOptions
  def initialize(name, self_class_name, options = {})
    defaults = {
      foreign_key: "#{self_class_name.to_s.downcase}_id".to_sym,
      primary_key: :id,
      class_name: name.to_s.singularize.camelcase
    }
    ivars = defaults.merge(options)
    @foreign_key = ivars[:foreign_key]
    @primary_key = ivars[:primary_key]
    @class_name = ivars[:class_name]
  end
end
