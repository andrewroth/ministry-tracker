class Exception
  def blame_file!( file )
    puts "CULPRIT >> '#{file.to_s}' # #{self.to_s}"
  end
end
