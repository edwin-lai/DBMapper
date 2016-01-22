require_relative '02_searchable'
require 'active_support/inflector'

# Phase IIIa
class AssocOptions
  attr_accessor(
    :foreign_key,
    :class_name,
    :primary_key
  )

  def model_class
    # ...
    class_name.constantize
  end

  def table_name
    # ...
    model_class.table_name
  end
end

class BelongsToOptions < AssocOptions
  def initialize(name, options = {})
    # ...
    defaults = {
      foreign_key: "#{name.to_s}_id".to_sym,
      primary_key: :id,
      class_name: "#{name.to_s}".camelcase
    }
    ivars = defaults.merge(options)
    @foreign_key = ivars[:foreign_key]
    @primary_key = ivars[:primary_key]
    @class_name = ivars[:class_name]
  end
end

class HasManyOptions < AssocOptions
  def initialize(name, self_class_name, options = {})
    # ...
    defaults = {
      foreign_key: "#{self_class_name.to_s.downcase}_id".to_sym,
      primary_key: :id,
      class_name: "#{name.to_s.singularize}".camelcase
    }
    ivars = defaults.merge(options)
    @foreign_key = ivars[:foreign_key]
    @primary_key = ivars[:primary_key]
    @class_name = ivars[:class_name]
  end
end

module Associatable
  # Phase IIIb
  def belongs_to(name, options = {})
    # ...
    options = BelongsToOptions.new(name, options)
  end

  def has_many(name, options = {})
    HasManyOptions.new(name, options)
    # ...
  end

  def assoc_options
    # Wait to implement this in Phase IVa. Modify `belongs_to`, too.
  end
end

class SQLObject
  # Mixin Associatable here...
end
