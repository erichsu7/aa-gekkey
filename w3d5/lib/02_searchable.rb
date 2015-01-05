require_relative 'db_connection'
require_relative '01_sql_object'

module Searchable
  def where(params)
    DBConnection.execute(<<-SQL,*params.values.map{|v| v.to_s}).map{|row| self.new(row)}
      SELECT *
      FROM #{self.table_name}
      WHERE #{params.keys.map { |k| k.to_s + ' = ?' } .join(' AND ')}
    SQL
  end
end

class SQLObject
  extend Searchable
end
