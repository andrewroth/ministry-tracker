Factory.define :user_code_1, :class => UserCode, :singleton => true do |p|
  p.id '1'
  p.user_id '1'
  p.code 'code'
  p.pass "\004\b{\000"
end
