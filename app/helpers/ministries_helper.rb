module MinistriesHelper
  def ministry_to_json(expand)
    json = "["
    expand.children.each do |ministry| 
      if is_ministry_admin(expand) || @my.ministry_tree.include?(ministry)
        json += '{"text":"' + ministry.name + '",' 
        json +=  '"id":"' + ministry.id.to_s + '",'
        json += '"singleClickExpand":true,'
        if ministry.children.count == 0
          json += '"cls":"file","expanded":true,"leaf":true'
        else 
          json += '"cls":"folder"'
        end
        if params[:node] != @ministry.id && ministry.descendants.include?(@ministry) #.children.empty?
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
