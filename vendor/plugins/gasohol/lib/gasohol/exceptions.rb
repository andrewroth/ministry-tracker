# Errors for Gashol
module Gasohol
  class MissingConfig < StandardError; end;   # config options weren't passed in when Gasohol was instantiated
  class MissingURL < StandardError; end;      # a URL wasn't provided in the config options to Gasohol
end