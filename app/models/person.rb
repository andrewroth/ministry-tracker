class Person < ActiveRecord::Base
  load_mappings
  include Common::Person
end
