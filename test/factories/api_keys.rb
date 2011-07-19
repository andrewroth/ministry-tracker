Factory.define :api_key_1, :class => ApiKey, :singleton => true do |a|
  a.id '1'
  a.user_id '1'
  a.login_code_id '2'
  a.purpose 'testing'
end

