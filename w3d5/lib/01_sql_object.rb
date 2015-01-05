require_relative 'db_connection'
require 'active_support/inflector'
# NB: the attr_accessor we wrote in phase 0 is NOT used in the rest
# of this project. It was only a warm up.

class Hash
  def to_options #rails method; replaces strings with symols in indices
    Hash[self.map{|k,v| [k.to_sym,v]}]
  end
end

class SQLObject
  def self.columns
    @columns ||= DBConnection.execute2(<<-SQL).first.map { |s| s.to_sym }
      SELECT *
      FROM #{table_name}
      LIMIT 0
    SQL
  end

  def self.finalize!
    columns.each do |col|
      define_method("#{col}") { self.attributes[col] }
      define_method("#{col}=") { |val| self.attributes[col] = val }
    end
  end

  def self.table_name=(table_name)
    @table_name = table_name
  end

  def self.table_name
    @table_name || self.to_s.tableize
  end

  def self.all
    parse_all(DBConnection.execute(<<-SQL).map { |row| row.to_options } )
      SELECT *
      FROM #{table_name}
    SQL
  end

  def self.parse_all(results)
    results.map { |row| self.new(row) }
  end

  def self.find(id)
    found = DBConnection.execute(<<-SQL, id).first
      SELECT *
      FROM #{table_name}
      WHERE id = ?
      LIMIT 1
    SQL

    return nil unless found

    self.new(found.to_options)
  end

  def initialize(params = {})
    params = params.to_options if params.keys.first.is_a?(String)
    if (params.keys - self.class.columns).size > 0
      raise "unknown attribute '#{(params.keys - self.class.columns).first.to_s}'"
    end
    @attributes = params
  end

  def attributes
    @attributes ||= {}
  end

  def attribute_values
    attribute_keys.map { |val| self.send(val) }
  end

  def attribute_keys
    self.class.columns
  end

  def insert
    DBConnection.execute(<<-SQL, *attribute_values)
      INSERT INTO
        #{self.class.table_name} (#{attribute_keys.map { |k| k.to_s } .join(', ')})
      VALUES
        (#{(['?'] * attribute_values.size).join(', ')})
    SQL
    self.id = DBConnection.last_insert_row_id
  end

  def update
    DBConnection.execute(<<-SQL, *attribute_values, self.id)
      UPDATE #{self.class.table_name}
      SET #{attribute_keys.map { |k| k.to_s + ' = ?' } .join(', ')}
      WHERE id = ?
    SQL
  end

  def save
    if self.id
      update
    else
      insert
    end
  end
end
