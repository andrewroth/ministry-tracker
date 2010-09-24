class RetireManageStaffPermission < ActiveRecord::Migration
  def self.up
    p = Permission.first(:conditions => {:controller => "staff", :action => "index"})

    if p.present?
      MinistryRolePermission.all(:conditions => {:permission_id => p.id}).each {|mrp| mrp.destroy}
    end
  end

  def self.down
    p = Permission.first(:conditions => {:controller => "staff", :action => "index"})

    if p.present?
      StaffRole.all(:conditions => {:involved => 1}).each do |mr|
        MinistryRolePermission.create!({ :permission_id => p.id, :ministry_role_id => mr.id })
      end
    end
  end
end
