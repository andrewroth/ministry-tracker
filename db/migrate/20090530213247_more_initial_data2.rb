# TODO: it would be better to put these into fixtures and make a task for loading
# all test fixtures into the current db
class MoreInitialData2 < ActiveRecord::Migration
  def self.add_campus(m, c_id)
    m.campuses << Campus.find(c_id) if m.campuses.find_all_by_id(c_id).empty?
  end

  def self.up
    if RAILS_ENV == 'development'
      # add a bunch of campuses
      foo = Ministry.find_by_name 'foo'
      add_campus foo, 1
      add_campus foo, 2
      add_campus foo, 3
      foo.save!

      bar = Ministry.find_by_name 'bar'
      add_campus bar, 3
      add_campus bar, 4
      add_campus bar, 5
      bar.save!

      # make admins true admins
      for mi in MinistryRole.find_by_name('Admin').ministry_involvements
        mi.admin = true
        mi.save!
      end
    end
  end

  def self.down
    if RAILS_ENV == 'development'
      # reverse campus assignments
      foo = Ministry.find_by_name 'foo'
      foo.campuses.delete_if { |c| [1, 2, 3].include? c.id }
      foo.save!

      bar = Ministry.find_by_name 'bar'
      bar.campuses.delete_if { |c| [3, 4, 5].include? c.id }
      bar.save!
      
      # no way of knowing who was admin, but it doesn't really matter
    end
  end
end
