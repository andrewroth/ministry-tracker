fbsession = RFacebook::FacebookWebSession.new(FACEBOOK["key"], FACEBOOK["secret"])
users = User.find(:all, :conditions => {:facebook_hash => nil})
# Group users in sections of xxx
group_by = 200
groups = (users.length / group_by).ceil + 1
groups.times do |i|
  start = i * group_by
  finish = ((i+1) * group_by)
  email_hashes = []
  users[start..finish].each do |user|
    crc = Zlib.crc32(user.username.downcase)
    md5 = Digest::MD5.hexdigest(user.username.downcase)
    string = "#{crc}_#{md5}"
    email_hashes << {:email_hash => string}
  end
  res = fbsession.connect_registerUsers(:accounts => email_hashes.to_json)
  users[start..finish].each do |user|
    crc = Zlib.crc32(user.username.downcase)
    md5 = Digest::MD5.hexdigest(user.username.downcase)
    string = "#{crc}_#{md5}"
    user.update_attribute(:facebook_hash, string)
  end
  puts "#{start} - #{finish}"
  sleep(10) # Thottle the requests so facebook doesn't get angry
end
