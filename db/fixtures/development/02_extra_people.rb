a = Ministry.find_by_name 'foo'
b = Ministry.find_by_name 'bar'

def username(r, m)
  "#{r.name.underscore.gsub(' ','_')}@#{m.name}.com"
end

def first_name(r)
  r.name.camelize.gsub(' ','')
end

# create a bunch of users
for m in [a, b]
  for r in MinistryRole.find :all, :order => :position
    u = User.seed(:username) do |u|
      u.username = username(r,m)
      u.plain_password = 'testuser'
      u.password_confirmation = 'testuser'
    end

    p = Person.seed(:user_id) do |p|
      p.first_name = first_name(r)
      p.last_name = 'User'
      p.user_id = u.id
    end

    mi = MinistryInvolvement.seed(:person_id, :ministry_id) do |mi|
      mi.person_id = p.id
      mi.ministry_id = m.id
      mi.ministry_role_id = r.id
      mi.admin = (r.name == 'Admin')
    end
  end
end

