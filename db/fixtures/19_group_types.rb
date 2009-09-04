GroupType.seed(:group_type) do |gt|
  gt.group_type = I18n.t :Bible_Study, :default => 'Bible Study' 
  gt.public = true
  gt.mentor_priority = true
  gt.ministry_id = 1
end