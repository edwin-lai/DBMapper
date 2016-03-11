require_relative 'association_options'

class BelongsToOptions < AssociationOptions
  def initialize(name, options = {})
    defaults = {
      foreign_key: "#{name}_id".to_sym,
      primary_key: :id,
      class_name: name.to_s.camelcase
    }
    ivars = defaults.merge(options)
    @foreign_key = ivars[:foreign_key]
    @primary_key = ivars[:primary_key]
    @class_name = ivars[:class_name]
  end
end
