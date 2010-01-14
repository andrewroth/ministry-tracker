ENV["RAILS_ENV"] = "test"
require File.expand_path(File.dirname(__FILE__) + "/../config/environment")
require 'test_help'

class ActiveSupport::TestCase
  include ActionController::TestProcess
  # Transactional fixtures accelerate your tests by wrapping each test method
  # in a transaction that's rolled back on completion.  This ensures that the
  # test database remains unchanged so your fixtures don't have to be reloaded
  # between every test method.  Fewer database queries means faster tests.
  #
  # Read Mike Clark's excellent walkthrough at
  #   http://clarkware.com/cgi/blosxom/2005/10/24#Rails10FastTesting
  #
  # Every Active Record database supports transactions except MyISAM tables
  # in MySQL.  Turn off transactional fixtures in this case; however, if you
  # don't care one way or the other, switching from MyISAM to InnoDB tables
  # is recommended.
  #
  # The only drawback to using transactional fixtures is when you actually 
  # need to test transactions.  Since your test is bracketed by a transaction,
  # any transactions started in your code will be automatically rolled back.
  self.use_transactional_fixtures = true

  # Instantiated fixtures are slow, but give you @david where otherwise you
  # would need people(:david).  If you don't want to migrate your existing
  # test cases which use the @david style and don't mind the speed hit (each
  # instantiated fixtures translates to a database query per test method),
  # then set this back to true.
  self.use_instantiated_fixtures  = false

  # Setup all fixtures in test/fixtures/*.(yml|csv) for all tests in alphabetical order.
  #
  # Note: You'll currently still have to declare fixtures explicitly in integration tests
  # -- they do not yet inherit this setting
  fixtures :all

  # Add more helper methods to be used by all tests here...
  def login(username = 'josh.starcher@example.com')
    @user = User.find(:first, :conditions => {:username => username})
    @request.session[:user] = @user.id
    @request.session[:ministry_id] = 1
    @person = @user.person
  end
  
  protected
    def upload_file(options = {})
      use_temp_file options[:filename] do |file|
        att = attachment_model.create :uploaded_data => fixture_file_upload(file, options[:content_type] || 'image/png')
        att.reload unless att.new_record?
        return att
      end
    end
        
    def use_temp_file(fixture_filename)
      temp_path = File.join('/tmp', File.basename(fixture_filename))
      FileUtils.mkdir_p File.join(fixture_path, 'tmp')
      FileUtils.cp File.join(fixture_path, fixture_filename), File.join(fixture_path, temp_path)
      yield temp_path
    ensure
      FileUtils.rm_rf File.join(fixture_path, 'tmp')
    end
end
# 
# 
# class ActiveSupport::TestCase #:nodoc:
#   include ActionController::TestProcess
#   def create_fixtures(*table_names)
#     if block_given?
#       Fixtures.create_fixtures(ActiveSupport::TestCase.fixture_path, table_names) { yield }
#     else
#       Fixtures.create_fixtures(ActiveSupport::TestCase.fixture_path, table_names)
#     end
#   end
# 
#   def setup
#     Attachment.saves = 0
#     DbFile.transaction { [Attachment, FileAttachment, OrphanAttachment, MinimalAttachment, DbFile].each { |klass| klass.delete_all } }
#     attachment_model self.class.attachment_model
#   end
#   
#   def teardown
#     FileUtils.rm_rf File.join(File.dirname(__FILE__), 'files')
#   end
# 
#   self.use_transactional_fixtures = true
#   self.use_instantiated_fixtures  = false
# 
#   def self.attachment_model(klass = nil)
#     @attachment_model = klass if klass 
#     @attachment_model
#   end
# 
#   def self.test_against_class(test_method, klass, subclass = false)
#     define_method("#{test_method}_on_#{:sub if subclass}class") do
#       klass = Class.new(klass) if subclass
#       attachment_model klass
#       send test_method, klass
#     end
#   end
# 
#   def self.test_against_subclass(test_method, klass)
#     test_against_class test_method, klass, true
#   end
# 
#   protected
#     def upload_file(options = {})
#       use_temp_file options[:filename] do |file|
#         att = attachment_model.create :uploaded_data => fixture_file_upload(file, options[:content_type] || 'image/png')
#         att.reload unless att.new_record?
#         return att
#       end
#     end
# 
#     def upload_merb_file(options = {})
#       use_temp_file options[:filename] do |file|
#         att = attachment_model.create :uploaded_data => {"size" => file.size, "content_type" => options[:content_type] || 'image/png', "filename" => file, 'tempfile' => fixture_file_upload(file, options[:content_type] || 'image/png')}
#         att.reload unless att.new_record?
#         return att
#       end
#     end
#     
#     def use_temp_file(fixture_filename)
#       temp_path = File.join('/tmp', File.basename(fixture_filename))
#       FileUtils.mkdir_p File.join(fixture_path, 'tmp')
#       FileUtils.cp File.join(fixture_path, fixture_filename), File.join(fixture_path, temp_path)
#       yield temp_path
#     ensure
#       FileUtils.rm_rf File.join(fixture_path, 'tmp')
#     end
# 
#     def assert_created(num = 1)
#       assert_difference attachment_model.base_class, :count, num do
#         if attachment_model.included_modules.include? DbFile
#           assert_difference DbFile, :count, num do
#             yield
#           end
#         else
#           yield
#         end
#       end
#     end
#     
#     def assert_not_created
#       assert_created(0) { yield }
#     end
#     
#     def should_reject_by_size_with(klass)
#       attachment_model klass
#       assert_not_created do
#         attachment = upload_file :filename => '/files/rails.png'
#         assert attachment.new_record?
#         assert attachment.errors.on(:size)
#         assert_nil attachment.db_file if attachment.respond_to?(:db_file)
#       end
#     end
#     
#     def assert_difference(object, method = nil, difference = 1)
#       initial_value = object.send(method)
#       yield
#       assert_equal initial_value + difference, object.send(method)
#     end
#     
#     def assert_no_difference(object, method, &block)
#       assert_difference object, method, 0, &block
#     end
#     
#     def attachment_model(klass = nil)
#       @attachment_model = klass if klass 
#       @attachment_model
#     end
# end
