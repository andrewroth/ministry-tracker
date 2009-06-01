module DashboardHelper

  def find_join_requests(grp)
      
      #Ensure that only (co)leaders are able to view any group join requests
      grp_leader = false
      leaders = grp.group_involvements.find(:all, :conditions =>  { :level => ["leader", "coleader"] } )
      leaders.each do |l|
        if l.person_id = @my.id
          grp_leader = true
        end
      end
    
      (grp_leader == true) ? grp.group_involvements.find(:all, :conditions => "requested = true") : []
      
    end 

end
