module SchoolYearsHelper
  def school_year_options
    return @school_year_options if @school_year_options
    years = SchoolYear.all
    years.sort!{ |y1, y2| t("years_order.#{y1.translation_key}").to_i <=> t("years_order.#{y2.translation_key}").to_i }
    @school_year_options = years.collect {|sy| [t("years.#{sy.translation_key}"), sy.id]}.insert(0, ['',''])
  end
end
