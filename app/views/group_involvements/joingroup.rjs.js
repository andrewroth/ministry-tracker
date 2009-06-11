page.replace_html("groupType"+@group_type_id, :partial => "groups/groups_to_join")
page[:spinnergt].hide
update_flash(page, flash[:notice])
