class SiteMultilingualLabel < ActiveRecord::Base
  load_mappings
  include Site::SiteMultilingualLabel
end
