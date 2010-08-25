class AddAwesomeNestedSetColumnToMinistries < ActiveRecord::Migration
  def self.up
    change_table Ministry.table_name do |t|
      t.integer :lft
      t.integer :rgt
    end
    #add_column Ministry.table_name

    add_index Ministry.table_name, :lft
    add_index Ministry.table_name, :rgt
    add_index Ministry.table_name, :parent_id

    Ministry.rebuild!
  end

  def self.down
    begin
    remove_column Ministry.table_name, :lft
    remove_column Ministry.table_name, :rgt
    rescue
    end

    begin
    remove_index Ministry.table_name, :lft
    remove_index Ministry.table_name, :rgt
    remove_index Ministry.table_name, :parent_id
    rescue
    end
  end
end
