page.replace_html("groups", :partial => "dashboard/groups")
update_flash(page)
page[:spinnergt].hide
