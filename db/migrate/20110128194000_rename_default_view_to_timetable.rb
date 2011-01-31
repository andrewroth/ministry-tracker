class RenameDefaultViewToTimetable < ActiveRecord::Migration
  def self.up
    views = View.all(:conditions => {:title => "Default"})

    views.each do |view|
      view.title = "Timetable"
      view.save!
    end
  end

  def self.down
    views = View.all(:conditions => {:title => "Timetable"})

    views.each do |view|
      view.title = "Default"
      view.save!
    end
  end
end
