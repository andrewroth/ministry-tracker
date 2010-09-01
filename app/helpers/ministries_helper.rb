module MinistriesHelper
  def ministry_to_json(expand)
    json = "["
    my_tree = @my.ministry_tree
    ministries_to_root_ids = @ministry.ancestors.collect(&:id)
    expand.children.each do |ministry| 
      if is_ministry_admin(expand) || my_tree.include?(ministry)
        json += '{"text":"' + ministry.name + '",' 
        json +=  '"id":"' + ministry.id.to_s + '",'
        json += '"singleClickExpand":true,'
        if ministry.leaf?
          json += '"cls":"file","expanded":true,"leaf":true'
        else 
          json += '"cls":"folder"'
        end
        if ministries_to_root_ids.include?(ministry.id)
          json += ',"expanded":true'
        end
        json += '}'
        json += ',' unless ministry == expand.children.last
      end 
    end
    json += ']'
    json
  end
end
