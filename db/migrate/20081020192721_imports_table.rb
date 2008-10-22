class ImportsTable < ActiveRecord::Migration
  def self.up
    create_table :imports, :force => true do |t|
      t.integer :person_id
      t.integer :parent_id, :size, :height, :width
      t.string :content_type, :filename, :thumbnail
      
      t.timestamps
    end
  end

  def self.down
    drop_table :imports
  end
end
