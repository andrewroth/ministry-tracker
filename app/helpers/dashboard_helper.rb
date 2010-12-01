module DashboardHelper
  def no_zero(v)
    (v.to_i == 0 ? "" : v)
  end

  def toggle_campus(c)
    %|toggle_campus("#{c.gsub("'","")}")|
  end
end
