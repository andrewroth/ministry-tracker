class ReportsController < ApplicationController
  
  layout 'manage'
  

  def index
    @possible_tree_heads = []
    if @ministry.campuses.find :first
      @cur_min_camp = MinistryCampus.find_by_campus_id_and_ministry_id(@ministry.campuses.find(:first).id, @ministry.id) 
    
      if @cur_min_camp
        @cur_tree_head = @cur_min_camp.tree_head
      end
      if @cur_min_camp 
        @cur_camp = @cur_min_camp.campus
      end
      get_possible_tree_heads
    end
    
  end

  
  
  private
  def get_possible_tree_heads
    @possible_tree_heads = []
    min_people = @ministry.people
    min_camp_people = []
    min_people.each do |person|
      if @cur_camp.people.find :first, :conditions => {:id => person.id}
        min_camp_people << person
      end
    end
    
    #Don't know why this doesn't accept people when I have cur_role_type == "StaffRole", even when it is equal to "StaffRole" Leave it here for now
    min_camp_people.each do |person|
    cur_role_type = person.ministry_involvements.find(:first, :conditions => {:ministry_id => @ministry.id}).ministry_role.type
      if cur_role_type #== "StaffRole"
        @possible_tree_heads << person
      end
    end
  end
end
