# poor man's locking solution since we can't lock mysq.time_zone_names
# my concurrency prof would be disappointed....
class Lock < ActiveRecord::Base
  def self.establish_lock(name)
    l = Lock.find_or_create_by_name name
    while l.locked
      sleep 1 # busy waiting :(
      l.reload
    end
    l.locked = true
    l.save!
  end

  def self.free_lock(name)
    l = Lock.find_or_create_by_name name
    l.locked = false
    l.save!
  end
end
