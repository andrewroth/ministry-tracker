require_model 'view'

class View < ActiveRecord::Base
  include Pulse::Ca::View
end
