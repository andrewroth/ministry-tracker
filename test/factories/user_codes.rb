Factory.define :user_code_1, :class => UserCode, :singleton => true do |c|
  c.id '1'
  c.user_id '1'
  c.login_code_id '1'
  c.pass "\004\b{\000"
end

