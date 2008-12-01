class HelperGenerator < Rails::Generator::NamedBase
  def manifest
    record do |m|
      m.class_collisions "#{class_name}Helper", "#{class_name}HelperTest"
      
      m.directory File.join('app/helpers', class_path)
      m.directory File.join('test/helpers', class_path)
      
      m.template 'helper.rb', 
                  File.join('app/helpers', 
                            class_path, 
                            "#{file_name}_helper.rb"), 
                  :assigns => { :helper_methods => @args }
      
      m.template 'helper_test.rb', 
                  File.join('test/helpers', 
                            class_path, 
                            "#{file_name}_helper_test.rb"), 
                  :assigns => { :helper_methods => @args }
    end
  end
  
  protected
    def banner
      "Usage: #{$0} #{spec.name} HelperName [methods ...]"
    end
end
