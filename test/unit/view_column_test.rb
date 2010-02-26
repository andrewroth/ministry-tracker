require File.dirname(__FILE__) + '/../test_helper'

class ViewColumnTest < ActiveSupport::TestCase



  def test_create_view_column
    Factory(:column_1)
    Factory(:column_2)
    Factory(:column_3)
    Factory(:column_4)
  
    Factory(:view_1)
    Factory(:view_2)

    Factory(:viewcolumn_1)
    Factory(:viewcolumn_2)
    Factory(:viewcolumn_3)
    
    view = View.find(:first)
    view.build_query_parts!
    old_tables = view.tables_clause
    vc = ViewColumn.create(:column_id => 4, :view_id => view.id)
    assert_not_equal(vc.view.tables_clause, old_tables)
  end
end
