
class UpdateStateColumnToStateId < ActiveRecord::Migration
  def self.up
    c = Column.find :first, :conditions => { # don't clobber any data
      :title => 'State',
      :update_clause => nil,
      :from_clause => 'CurrentAddress',
      :select_clause => 'state',
      :column_type => nil,
      :writeable => nil,
      :join_clause => "address_type = 'current'",
      :source_model => nil,
      :source_column => nil,
      :foreign_key => nil
    }
    return unless c

    c.from_clause = 'State'
    c.select_clause = 'name'
    c.join_clause = nil
    c.source_model = "CurrentAddress"
    c.source_column = "state_id"
    c.foreign_key = "id"
    c.save!

    View.all.each { |v| v.build_query_parts! }
  end

  def self.down
    c = Column.find :first, :conditions => { # don't clobber any data
      :title => 'State',
      :update_clause => nil,
      :from_clause => 'State',
      :select_clause => 'name',
      :column_type => nil,
      :writeable => nil,
      :join_clause => nil,
      :source_model => "CurrentAddress",
      :source_column => "state_id",
      :foreign_key => "id"
    }
    return unless c

    c.from_clause = 'CurrentAddress'
    c.select_clause = 'state'
    c.join_clause = "address_type = 'current'"
    c.source_model = "CurrentAddress"
    c.source_column = nil
    c.foreign_key = nil
    c.save!

    View.all.each { |v| v.build_query_parts! }
  end
end
