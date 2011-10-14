
# this prevents a potential dead-lock when the server crashes without unlocking an existing lock

Lock.all.each {|lock| lock.locked = false}
