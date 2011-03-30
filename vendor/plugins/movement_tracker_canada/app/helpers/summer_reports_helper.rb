module SummerReportsHelper
  unloadable

  def average_from_array(array)
    if array.size > 0
      array.inject(0) { |s,v| s += v } / array.size
    else
      0
    end
  end
  
end
