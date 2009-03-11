module MinistriesHelper
  def ministry_to_json(expand)
    json = "["
    expand.children.each do |ministry| 
      if @my.ministry_tree.include?(ministry)
        json += '{"text":"' + ministry.name + '",' 
        json +=  '"id":"' + ministry.id.to_s + '",'
        json += '"singleClickExpand":true,'
        if ministry.children.empty? 
          json += '"cls":"file","expanded":true'
        else 
          json += '"cls":"folder"'
        end
        if params[:node] != @ministry && ministry.descendants.include?(@ministry) #.children.empty?
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
