page.replace_html("groupType"+@group_type_id, :partial => "groups/groups_to_join", :locals => {:gt => GroupType.find(@group_type_id)})
page[:spinnergt].hide
update_flash(page, flash[:notice])
