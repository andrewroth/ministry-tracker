Factory.define :user_1, :class => User, :singleton => true do |u|
  u.id '1'
  u.username 'josh.starcher@example.com'
  u.password  { User.encrypt('test') }
  u.guid 'F167605D-94A4-7121-2A58-8D0F2CA6E026'
  u.last_login { Date.today }
end

Factory.define :user_2, :class => User, :singleton => true do |u|
  u.id '2'
  u.username 'fred@uscm.org'
  u.password 'test'
  u.guid ''
  u.last_login { Date.today }
end

Factory.define :user_3, :class => User, :singleton => true do |u|
  u.id '3'
  u.username 'sue@student.org'
  u.password 'bob'
  u.guid ''
  u.last_login { Date.today }
end

Factory.define :user_4, :class => User, :singleton => true do |u|
  u.id '4'
  u.username 'user_with_no_ministry_involvements'
  u.password  { User.encrypt('test') }
  u.guid '8a4ea810-0cc2-4062-ae87-27e90e641b7a'
  u.last_login { Date.today }
end

Factory.define :user_5, :class => User, :singleton => true do |u|
  u.id '5'
  u.username 'min_leader_with_no_permanent_address'
  u.password  { User.encrypt('test') }
  u.guid '253b648c-3537-464c-b97a-e2d7e2c748b8'
  u.last_login { Date.today }
end

Factory.define :user_6, :class => User, :singleton => true do |u|
  u.id '6'
  u.username 'staff_on_ministry_with_no_campus'
  u.password  { User.encrypt('test') }
  u.guid '253b648c-3537-464c-b97a-e2d7e2c748b9'
  u.last_login { Date.today }
end
