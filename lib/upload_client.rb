require 'drb'
DRb.start_service

def get_status
  DRbObject.new nil, 'druby://0.0.0.0:2999'
end