class Month < ActiveRecord::Base
  unloadable
  
  load_mappings
  
  include Legacy::Stats::Month

  def self.all_in_order
    Month.all(:joins => :year, :order => "year_desc ASC, month_number ASC")
  end

  def self.all_for_grouped_options
    Year.all.collect{ |y|
      [ y.year_desc, y.months.collect{ |m| [ m.month_desc, "m_#{m.id}" ] } ]
    }
  end
end
