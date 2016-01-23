require_relative 'db_connection'
require_relative '01_sql_object'

module Searchable
  def cache
    @cache ||= {}
  end

  def where(params)
    # ...
    where_line = params.keys.map { |key| "#{key} = ?" }.join(' AND ')
    cache
    if @cache[params].nil?
      results = DBConnection.execute(<<-SQL, *params.values)
        SELECT
          *
        FROM
          #{table_name}
        WHERE
          #{where_line}
      SQL
      @cache[params] = results
    end

    @cache[params].map { |data| new(data) }
  end
end

class SQLObject
  # Mixin Searchable here...
  extend Searchable
end
