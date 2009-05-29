class AddMoreJoinStringsToColumns < ActiveRecord::Migration
  def self.up
    # NOTE - deafults are implemented in the View model's build_query_parts
    add_column :columns, :source_model, :string #, 'Person' default
    add_column :columns, :source_column, :string # 'id' default
    add_column :columns, :foreign_key, :string #'person_id' deafult
  end

  def self.down
    remove_column :columns, :source_model
    remove_column :columns, :source_column
    remove_column :columns, :foreign_key
  end
end
