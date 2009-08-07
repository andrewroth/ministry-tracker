module Rails
  def self.public_path
    File.dirname(__FILE__)
  end
end

class Application < ActionController::Base
  
  def runtime_error
    raise "This is a runtime error that we should be emailed about"
  end
  
  def record_not_found
    raise ActiveRecord::RecordNotFound
  end
  
  def local_request?
    false
  end
  
end

class OldStyle < Application
  include ExceptionNotifiable
    
end

class SpecialErrorThing < RuntimeError
end

class NewStyle < Application
  include ExceptionNotifiable
    
  rescue_from ActiveRecord::RecordNotFound do |exception|
    render :text => "404", :status => 404
  end

  rescue_from RuntimeError do |exception|
    render :text => "500", :status => 500
  end
end
