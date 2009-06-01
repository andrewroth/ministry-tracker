# Be sure to restart your server when you modify this file.


# If we do not do this then we get a FAILSAFE 500 Internal Server Error
# when a user tries to add a permission to a role. :D
# FIXME: remove this when we get a version of Rails that does not break Rack spec
# BUG: 1896 - role permissions don't work
# see also: http://groups.google.com/group/rack-devel/browse_thread/thread/4bce411e5a389856/b23eb520a35a502a?lnk=raot&pli=1
# hack, hack, hack...
module Mime 
  class Type 
    def split(*args) 
      to_s.split(*args) 
    end 
  end 
end

# Add new mime types for use in respond_to blocks:
# Mime::Type.register "text/richtext", :rtf
# Mime::Type.register_alias "text/html", :iphone
Mime::Type.register "application/vnd.ms-excel", :xls
Mime::Type.register_alias "text/html", :iphone
