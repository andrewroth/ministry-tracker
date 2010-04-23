class SiteMultilingualLabel < ActiveRecord::Base
  load_mappings
  include Legacy::Site::SiteMultilingualLabel
end
