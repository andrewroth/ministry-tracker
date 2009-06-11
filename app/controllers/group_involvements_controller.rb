class GroupInvolvementsController < ApplicationController
  
  def create
    create_group_involvement
    refresh_page
  end
  
  def joingroup  
    params[:type] = params[:group_involvement][:level]
    params[:group_id] = params[:group_involvement][:group_id]
    @group_type_id = params[:gt_id]
    create_group_involvement
    flash[:notice_group] = "Join request for <b>#{@group.name}</b> group sent!"
    respond_to do |format|
      format.js {
         render :update do |page|
            page.replace_html("groupType"+@group_type_id, :partial => "groups/groups_to_join")
            page[:flash_notice].fadeOut(4000)
            page[:spinnergt].hide
         end
      }
    end
  end
  
  def accept_request
    GroupInvolvement.find(params[:id]).update_attribute(:requested, false)
    flash[:notice_group] = "Group join request from <b>" + Person.find(GroupInvolvement.find(params[:id]).person_id).full_name + "</b> accepted!"
    respond_to do |format|
      format.js {
         render :update do |page|
            page.replace_html("groups", :partial => "dashboard/groups")
            page[:flash_notice].fadeOut(4000)
            page[:spinnergt].hide
         end
      }
    end
    
  end
  
  def decline_request
    person_id = GroupInvolvement.find(params[:id]).person_id
    GroupInvolvement.delete(params[:id])
    flash[:notice_group] = "Group join request from <b>" + Person.find(person_id).full_name + "</b> declined!"
    respond_to do |format|
      format.js {
         render :update do |page|
            page.replace_html("groups", :partial => "dashboard/groups")
            page[:flash_notice].fadeOut(4000)
            page[:spinnergt].hide
         end
      }
    end
  end
  
  def destroy
    if params[:members]
      GroupInvolvement.destroy_all(["#{_(:person_id, :group_involvement)} IN (?)", params[:members].join(',')])
    else
      raise "No members were selected to delete"
    end
    get_group
    refresh_page
  end
  
  def transfer
    if params[:members]
      GroupInvolvement.update_all(["#{_(:group_id, :group_involvement)} = ?", params[:transfer_to]], 
                                  ["#{_(:group_id, :group_involvement)} = ? AND " +
                                   "#{_(:level, :group_invovlement)} = ? AND " + 
                                   "#{_(:person_id, :group_involvement)} IN (?)", params[:id], params[:level], params[:members].join(',')])
    end
    get_group
    refresh_page
  end
  
  protected
    def find_by_person_id_and_group_id(person_id, group_id)
      GroupInvolvement.find(:first, :conditions => [_(:person_id, :group_involvement) + " = ? AND " + 
                                                          _(:group_id, :group_invovlement) + " = ? ", 
                                                          person_id, group_id])
    end
    
    def refresh_page
      respond_to do |format|
        format.html do 
          redirect_to "/#{@group.class.to_s.tableize}/#{params[:id]}"
        end
        format.js do
          render :update do |page|
            eval("@#{@group.class.to_s.underscore} =  @group")
            page[@group.class.to_s.underscore].replace_html(:partial => "#{@group.class.to_s.tableize}/show")
          end
        end
      end
    end

    def create_group_involvement
      # If the person is already in the group, find them. otherwise, create a new record
      @gi = find_by_person_id_and_group_id(params[:person_id], params[:group_id])
      @gi ||= GroupInvolvement.new(:person_id => params[:person_id], :group_id => params[:group_id])
      @gi.level = params[:type]  # set the level of involvement
      @gi.requested = params[:requested]
      @gi.save!
      @group = @gi.group
    end
end
