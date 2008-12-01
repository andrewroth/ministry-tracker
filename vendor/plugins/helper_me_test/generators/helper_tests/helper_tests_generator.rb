class HelperTestsGenerator < Rails::Generator::Base
  def manifest
    record do |m|
      unless @args.empty?
        @args.each do |helper_class|
          create_helper_test(m, helper_class)
        end
      else
        Dir.glob(File.join(RAILS_ROOT, 'app', 'helpers/**/*_helper.rb')) do |helper_file|
          # get full file path without extension
          helper_full_path = File.expand_path(helper_file).gsub(/\.rb$/, '')
          # get path relative to helpers directory
          helper_relative_path = helper_full_path.gsub(/^#{Regexp.escape(File.join(RAILS_ROOT, 'app', 'helpers'))}\//, '')

          create_helper_test(m, helper_relative_path)
        end
      end
    end
  end
  
  protected
    def banner
      "Usage: #{$0} #{spec.name} [SampleHelper Admin::AnotherHelper ...]"
    end
    
    def add_options!(opt)
      opt.separator ''
      opt.separator 'Options:'
      opt.on("--skip-method-tests",
             "Don't add test methods to the test-case file for the helpers") { |v| options[:skip_method_tests] = v }
    end
  
  private
    def create_helper_test(manifest, helper_name)
      helper_file_name, helper_relative_dir, helper_full_name = extract_names_paths(helper_name)
      
      unless options[:skip_method_tests]
        helper_methods = helper_full_name.constantize.public_instance_methods
      end

      manifest.class_collisions "#{helper_full_name}Test"

      manifest.directory File.join('test/helpers', helper_relative_dir)

      manifest.template 'helper_test.rb', 
                  File.join('test/helpers', 
                            helper_relative_dir, 
                            "#{helper_file_name}_test.rb"), 
                  :assigns => { :helper_full_name => helper_full_name, 
                                :helper_methods => helper_methods }
    end
    
    # Extract modules from filesystem-style or ruby-style path:
    #   good/fun/stuff
    #   Good::Fun::Stuff
    # produce the same results.
    def extract_names_paths(name)
      modules = name.include?('/') ? name.split('/') : name.split('::')
      file_name    = modules.pop.underscore
      relative_dir    = modules.map { |m| m.underscore }.join('/')
      full_module_name = (modules.map { |m| m.camelcase } + [file_name.camelcase]).join('::')
      [file_name, relative_dir, full_module_name]
    end
end
