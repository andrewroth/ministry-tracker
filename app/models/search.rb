# Custom search parameters on the directory are storable
class Search < ActiveRecord::Base
  load_mappings
  
  def table_clause
    JSON::Parser.new(tables).parse.collect {|table| "LEFT JOIN #{table[0].constantize.table_name} as #{table[0].to_s} on #{table[1]}" }.join('')
  end
end
