Factory.define :live_notice, :class => Notice do |f|
  f.id '1'
  f.message "live notice"
  f.live true
end

Factory.define :not_live_notice, :class => Notice do |f|
  f.id '2'
  f.message "not live notice"
  f.live false
end
