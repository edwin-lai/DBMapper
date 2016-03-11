require_relative 'db_connection'
require_relative 'searchable'
require_relative 'belongs_to_options'
require_relative 'has_many_options'
require 'active_support/inflector'

module Associable
  def belongs_to(name, options = {})
    options = BelongsToOptions.new(name, options)
    association_options
    @opts[name] = options
    define_method(name) do
      options.model_class
             .where(options.primary_key => send(options.foreign_key))
             .first
    end
  end

  def has_many(name, options = {})
    options = HasManyOptions.new(name, self, options)
    define_method(name) do
      options.model_class
             .where(options.foreign_key => send(options.primary_key))
    end
  end

  def association_options
    @opts ||= {}
  end

  def has_one_through(name, through_name, source_name)
    define_method(name) do
      through_options = self.class.association_options[through_name]
      source_options = through_options.model_class
                                      .association_options[source_name]
      data = DBConnection.execute(<<-SQL)
        SELECT
          #{source_options.model_class.table_name}.*
        FROM
          #{source_options.model_class.table_name}
        JOIN
          #{through_options.model_class.table_name}
        ON
          #{through_options.model_class.table_name}.#{source_options.foreign_key} = #{source_options.model_class.table_name}.#{source_options.primary_key}
        WHERE
          #{through_options.model_class.table_name}.#{through_options.primary_key} = #{send(through_options.foreign_key)}
      SQL
      data.map { |datum| source_options.model_class.new(datum) }.first
    end
  end
end
