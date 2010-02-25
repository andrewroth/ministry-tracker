require File.dirname(__FILE__) + '/../test_helper'

class ViewTest < ActiveSupport::TestCase
#  fixtures View.table_name, ViewColumn.table_name, Column.table_name

  def test_build_query_parts
    Factory(:column_1)
    Factory(:column_2)
    Factory(:column_3)
    Factory(:column_4)
  
    Factory(:view_1)
    Factory(:view_2)

    Factory(:viewcolumn_1)
    Factory(:viewcolumn_2)
    Factory(:viewcolumn_3)
    
    v = View.find(:first)
    assert tables = v.build_query_parts!
    assert(v.tables_clause.length > 0)
    assert_equal(5, tables.size)
  end
end
