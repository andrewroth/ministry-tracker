class ProfilePicture < ActiveRecord::Base
  load_mappings

  belongs_to :person, :class_name => "Person", :foreign_key => _("person_id")

  has_attachment :content_type => :image, 
                 :storage => $attachment_storage_mode, 
                 :max_size => 10.megabytes,
                 :resize_to => '400x400>',
                 :thumbnails => {:mini => '50x50>',
                                 :thumb => '100x100>',
                                 :medium => '200x200>' }
                                 
 validates_as_attachment
end
