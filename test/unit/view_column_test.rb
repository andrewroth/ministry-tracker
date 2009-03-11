require File.dirname(__FILE__) + '/../test_helper'

class ViewColumnTest < ActiveSupport::TestCase
  fixtures ViewColumn.table_name, View.table_name, Column.table_name

  def test_create_view_column
    view = View.find(:first)
    view.build_query_parts!
    old_tables = view.tables_clause
    vc = ViewColumn.create(:column_id => 4, :view_id => view.id)
    assert_not_equal(vc.view.tables_clause, old_tables)
  end
end
