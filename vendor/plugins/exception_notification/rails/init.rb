require "action_mailer"

require File.join(File.dirname(__FILE__), '..', 'lib', "super_exception_notifier", "custom_exception_classes")
require File.join(File.dirname(__FILE__), '..', 'lib', "super_exception_notifier", "custom_exception_methods")

$:.unshift "#{File.dirname(__FILE__)}/lib"

require "hooks_notifier"
require "exception_notifier"
require "exception_notifiable"
require "exception_notifier_helper"
require "notifiable"

Object.class_eval do include Notifiable end

#It appears that hte view path is auto-added by rails... hmmm.
#if ActionController::Base.respond_to?(:append_view_path)
#  puts "view path before: #{ActionController::Base.view_paths}"
#  ActionController::Base.append_view_path(File.join(File.dirname(__FILE__), 'app', 'views','exception_notifiable'))
#  puts "view path After: #{ActionController::Base.view_paths}"
#end
