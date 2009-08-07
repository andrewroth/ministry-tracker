require "action_mailer"
$:.unshift "#{File.dirname(__FILE__)}/lib"
require "exception_notifier"
require "exception_notifiable"
require "exception_notifier_helper"
require "notifiable"

Object.class_eval do include Notifiable end
