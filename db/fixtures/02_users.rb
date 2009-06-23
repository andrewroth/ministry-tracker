User.seed(:username) do |u|
  u.username = 'test.user@example.com'
  u.plain_password = 'testuser'
  u.password_confirmation = 'testuser'
end
