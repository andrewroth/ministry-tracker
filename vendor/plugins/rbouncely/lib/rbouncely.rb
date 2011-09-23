module Rbouncely
  
  VERSION = "0.0.1"
  
  LOGGER = Logger.new(STDOUT)
  
  DEFAULT_CONFIG = {:url => "http://api.bouncely.com/api/v1/{api_key}/{date}.{format}",
                   :api_key => "",
                   :format => "xml",
                   :date => "today"}
end
