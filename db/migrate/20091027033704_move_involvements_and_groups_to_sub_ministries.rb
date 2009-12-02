class MoveInvolvementsAndGroupsToSubMinistries < ActiveRecord::Migration
  def self.up
    if Ministry.count <= 3
      MinistryRolePermission.clear
      throw "do a db:seed to make the ministries first (note: permissions have also been cleared; the db:seed will recreate them)"
    end

    # update children cache
    for m in Ministry.all
      Ministry.connection.execute "UPDATE ministries SET ministries_count = #{m.children.count} WHERE id = #{m.id}"
      m.save!
    end

    @staff_role = StaffRole.find_by_name "Staff"
    @staff_team_role = StaffRole.find_by_name "Staff Team"
    @c4c = Ministry.find_by_name 'Campus for Christ'

    move_involvements
    move_groups
  end

  def self.down
  end

  def self.add_to_campus_team(p,c, rid = @staff_team_role.id)
    # assume the last ministry team found is the one we want to be on
    # so that c4c isn't used as the new team (whole point is to use subteams)
    mc = MinistryCampus.find_all_by_campus_id(c).last
    if mc
      m = mc.ministry
      STDOUT.puts " add to #{m.name}"
      mi = MinistryInvolvement.find_or_create_by_ministry_id_and_person_id m.id, p.id, rid
      mi.ministry_role_id = rid
      mi.start_date = Date.today
      mi.save!
    end
  end

  def self.move_involvements
    mis_to_end = []
    cis_to_end = []

    for r in MinistryRole.all
      for mi in r.ministry_involvements
        p = mi.person
        next unless p
        next if mi.archived?
        next unless mi.ministry_id == 2 # only c4c
        next if r == @staff_team_role

        # for staff, move all campus involvements to be ministry involvements
        if r.is_a?(StaffRole)
          STDOUT.print "[staff] #{p.full_name} (#{p.campus_involvements.length} CIs)"

          for ci in p.campus_involvements
            #puts "   #{ci.school_year_id}"
            next if ci.school_year_id.to_s == '10' # alumni

            add_to_campus_team p, ci.campus, @staff_team_role.id
            cis_to_end << ci.id
          end
        else
          STDOUT.print "[student] #{p.full_name}"
          # students just get their one involvement moved
          ci = p.campus_involvements.first
          if ci
            add_to_campus_team p, ci.campus, mi.ministry_role_id
          end
          mis_to_end << mi.id
        end

        # finish mis
        if mis_to_end.length > 100
          MinistryInvolvement.connection.execute "UPDATE ministry_involvements set end_date = '#{Date.today.strftime("%Y-%m-%d")}' where id in (#{mis_to_end.join(',')})" 
          mis_to_end.clear
        end
       
        # finish cis
        if cis_to_end.length > 100
          MinistryInvolvement.connection.execute "UPDATE campus_involvements set end_date = '#{Date.today.strftime("%Y-%m-%d")}' where id in (#{cis_to_end.join(',')})" 
          cis_to_end.clear
        end
       end
    end

    # now go through assignments
    for a in Assignment.find_all_by_assignmentstatus_id(3) # Staff
      STDOUT.print "[assignment] #{a.person.full_name}"
      add_to_campus_team a.person, a.campus
    end
  end

  def self.move_groups
    for g in Group.all
      if g.campus
        puts "[group] #{g.name}"
        mc = MinistryCampus.find_all_by_campus_id(g.campus.id).last
        g.ministry = mc.ministry
        g.save!
      end
    end
  end
end
