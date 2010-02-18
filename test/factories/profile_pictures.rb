Factory.define :profilepicture_1, :class => ProfilePicture do |p|
  p.id '1'
  p.person_id '50000'
  p.size '5'
  p.height '3'
  p.width '8'
  p.content_type 'image/jpeg'
  p.filename 'picture.jpg'
end

Factory.define :profilepicture_2, :class => ProfilePicture do |p|
  p.id '2'
  p.parent_id '1'
  p.size '5'
  p.height '3'
  p.width '8'
  p.content_type 'image/jpeg'
  p.filename 'picture_thumb.jpg'
  p.thumbnail 'thumb'
end

Factory.define :profilepicture_3, :class => ProfilePicture do |p|
  p.id '3'
  p.parent_id '1'
  p.size '5'
  p.height '3'
  p.width '8'
  p.content_type 'image/jpeg'
  p.filename 'picture_mini.jpg'
  p.thumbnail 'mini'
end

Factory.define :profilepicture_4, :class => ProfilePicture do |p|
  p.id '4'
  p.parent_id '1'
  p.size '5'
  p.height '3'
  p.width '8'
  p.content_type 'image/jpeg'
  p.filename 'picture_medium.jpg'
  p.thumbnail 'medium'
end
