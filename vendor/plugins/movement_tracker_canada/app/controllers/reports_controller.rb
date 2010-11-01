class ReportsController < ApplicationController
  unloadable

  def add_db_lines_from_report(report_name)
    input_lines.concat(stats_reports[report_name].sort { |a,b| a[1][:order] <=> b[1][:order]}.collect{|s| s[1][:column_type] == :database_column ? s : nil}.compact)
  end

  def input_lines
    @input_lines ||= []
    @input_lines
  end

  def validate(params)
    
  end

end