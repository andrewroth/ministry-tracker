page.replace_html("group_"+@group_id, :partial => "groups/joinable_group", :locals => {:joinable_group => Group.find(@group_id)})
page[:spinnergt].hide
update_flash(page, flash[:notice])
