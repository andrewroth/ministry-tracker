class GlobalProfile < ActiveRecord::Base
  def GlobalProfile.import
    f = File.read("global_profiles.csv")
    lines = f.split("\n")
    headers = lines.shift.split(",").collect{ |h| h =~ /"(.*)"/; $1.to_s }
    headers = headers.collect{ |h| h == "language1" ? "language" : h }
    columns = headers.collect(&:underscore)

    lines.each_with_index do |line, line_index|
      puts "line: #{line_index} GlobalProfile.count: #{GlobalProfile.count}"
      values = line.split(",", 10).collect{ |h| h =~ /"(.*)"/; $1.to_s }
      puts values.inspect

      conditions = {}
      columns.each_with_index do |column, i|
        conditions[column] = values[i]
      end

      # make entry
      #gp = GlobalProfile.find :first, :conditions => conditions
      #unless gp
        GlobalProfile.create! conditions
      #end

    end.length
  end
end
