page.replace_html("group_"+@group_id, :partial => "groups/group", :locals => {:group => Group.find(@group_id)})
page[:spinnergt].hide
update_flash(page, flash[:notice])
