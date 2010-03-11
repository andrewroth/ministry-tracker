Factory.define :email_1, :class => Email, :singleton => true, :singleton => true do |e|
  e.subject 'test'
  e.body "{{first_name}} {{last_name}}"
  e.sender_id '50000'
  e.people_ids "[50000, 1]"
  e.created_at  Time.now.to_s(:db) 
  e.updated_at  Time.now.to_s(:db) 
end

Factory.define :email_2, :class => Email, :singleton => true, :singleton => true do |e|
  e.subject 'test'
  e.body 'foob ar'
  e.sender_id '50000'
  e.search_id '1'
  e.created_at  Time.now.to_s(:db) 
  e.updated_at  Time.now.to_s(:db) 
end
