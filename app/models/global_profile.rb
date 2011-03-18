require 'csv'

class GlobalProfile < ActiveRecord::Base
  def GlobalProfile.import
    need_headers = true
    columns = nil

    CSV::Reader.parse(File.open('global_profiles.csv')) do |values|
      if need_headers
        headers = values.collect{ |h| h == "language1" ? "language" : h }
        columns = headers.collect(&:underscore)
        need_headers = false
      else
        #puts "GlobalProfile.count: #{GlobalProfile.count}"
        conditions = {}
        skip = false
        columns.each_with_index do |column, i|
          skip ||= values[i].nil?
          conditions[column] = values[i]
        end

        # make entry
        #gp = GlobalProfile.find :first, :conditions => conditions
        #unless gp
        GlobalProfile.create!(conditions) #unless skip
        #end

      end
    end
  end
end
