require_relative 'db_connection'
require 'active_support/inflector'
# NB: the attr_accessor we wrote in phase 0 is NOT used in the rest
# of this project. It was only a warm up.

class SQLObject
  def self.columns
    return @columns if @columns
    col = DBConnection.execute2(<<-SQL)[0]
      SELECT
        *
      FROM
        #{self.table_name}
    SQL
    @columns = col.map(&:to_sym)
  end

  def self.finalize!
    columns.each do |col|
      define_method(col) { @attributes[col] }
      define_method("#{col}=") do |thing|
        attributes
        @attributes[col] = thing
      end
    end
  end

  def self.table_name=(table_name)
    # ...
    @table_name = table_name
  end

  def self.table_name
    # ...
    @table_name = self.inspect.tableize if @table_name.nil?
    @table_name
  end

  def self.all
    # ...
    results = DBConnection.execute(<<-SQL)
      SELECT
        #{table_name}.*
      FROM
        #{table_name}
    SQL
    parse_all(results)
  end

  def self.parse_all(results)
    # ...
    results.map do |data|
      new(data)
    end
  end

  def self.find(id)
    # ...
    object_data = DBConnection.execute(<<-SQL)
      SELECT
        #{table_name}.*
      FROM
        #{table_name}
      WHERE
        id = #{id}
    SQL
    return nil if object_data == []
    new(*object_data)
  end

  def initialize(params = {})
    # ...
    params.each_key do |key|
      unless self.class.columns.include?(key.to_sym)
        fail "unknown attribute '#{key}'"
      end
    end

    params.each do |key, value|
      send "#{key}=", value
    end
  end

  def attributes
    # ...
    @attributes ||= {}
  end

  def attribute_values
    # ...
    self.class.columns.map { |col| send "#{col}" }
  end

  def insert
    # ...
    col_names = self.class.columns.join(', ')
    question_marks = Array.new(self.class.columns.size, '?').join(', ')
    DBConnection.execute(<<-SQL, *attribute_values)
      INSERT INTO
        #{self.class.table_name} (#{col_names})
      VALUES
        (#{question_marks})
    SQL
    @attributes[:id] = DBConnection.last_insert_row_id
  end

  def update
    # ...
    set_line = self.class.columns.map { |col| "#{col} = ?" }.join(', ')
    DBConnection.execute(<<-SQL, *attribute_values)
      UPDATE
          #{self.class.table_name}
        SET
          #{set_line}
        WHERE
          id = #{@attributes[:id]}
      SQL
  end

  def save
    @attributes.nil? ? insert : update
  end
end
