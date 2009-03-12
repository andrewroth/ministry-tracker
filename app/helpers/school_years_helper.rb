module SchoolYearsHelper
  def school_year_options
    @school_year_options ||= SchoolYear.find(:all).collect {|sy| ["#{sy.name}#{sy.level.present? ? ' (' + sy.level + ')' : ''}", sy.id]}
  end
end
