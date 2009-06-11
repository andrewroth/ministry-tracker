module DashboardHelper

  def find_join_requests(grp)
      
      #Ensure that only (co)leaders are able to view any group join requests
      grp_leader = nil
      leaders = grp.group_involvements.find(:all, :conditions =>  { :level => ["leader", "coleader"] } )
      leaders.each do |l|
        if (l.person_id == @my.id)
          grp_leader = true
        end
      end
    
      if (!grp_leader.nil?) 
        retval = grp.group_involvements.find(:all, :conditions => "requested = true") 
      else
        retval = []
      end
            
    end 
    
    #returns whether the user is in the group or not
    #should return false if the user group join request has not been granted yet
    def groupmember?(grp)
      requested_members = grp.group_involvements.find(:all, :conditions =>  { :requested => true } )
      requested_members.each do |rm|
        if (rm.person_id == @my.id)
          return false
        end
      end
      return true
    end

end
