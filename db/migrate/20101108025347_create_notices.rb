class CreateNotices < ActiveRecord::Migration
  def self.up
    create_table Notice.table_name do |t|
      t.text :message
      t.boolean :live

      t.timestamps
    end
  end

  def self.down
    drop_table Notice.table_name
  end
end
