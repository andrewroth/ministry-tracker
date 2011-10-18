# this prevents a potential dead-lock when the server crashes without unlocking an existing lock

begin
  Lock.all.each{ |lock| lock.locked = false; lock.save }
rescue
end
