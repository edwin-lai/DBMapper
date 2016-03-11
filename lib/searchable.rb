require_relative 'db_connection'

module Searchable
  def cache
    @cache ||= {}
  end

  def where(params)
    condition = params.keys.map { |key| "#{key} = ?" }.join(' AND ')
    cache
    if @cache[params].nil?
      results = fetch_results(condition, params.values)
      @cache[params] = results
    end

    @cache[params].map { |data| new(data) }
  end

  private

  def fetch_results(condition, values)
    DBConnection.execute(<<-SQL, *values)
      SELECT
        *
      FROM
        #{table_name}
      WHERE
        #{condition}
    SQL
  end
end
