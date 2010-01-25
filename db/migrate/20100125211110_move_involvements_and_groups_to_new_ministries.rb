class MoveInvolvementsAndGroupsToNewMinistries < ActiveRecord::Migration
  def self.up
    if Ministry.count <= 40
      throw "do a db:seed to first"
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
      if m == @c4c && rid == @staff_team_role.id
        rid = @staff_role.id if m == @c4c # force "Staff" role for c4c
      end
      STDOUT.puts " add to #{m.name}"
      mi = MinistryInvolvement.find_or_create_by_ministry_id_and_person_id m.id, p.id, rid
      mi.ministry_role_id = rid
      mi.start_date = Date.today
      mi.save!
    end
  end

  def self.move_involvements
    mis_to_end = []

    cids = [ 76, 88, 75, 63, 67, 48, 55, 72, 74, 77, 80, 84, 141 ]

    for r in StudentRole.all
      for mi in @c4c.ministry_involvements.find_all_by_end_date_and_ministry_role_id nil, r.id
        p = mi.person
        next unless p
        next if mi.archived?
        next if r == @staff_team_role

        STDOUT.print "[student #{p.id}] #{p.full_name}"
        # students just get their one involvement moved
        ci = p.campus_involvements.first
        if ci
          add_to_campus_team p, ci.campus, mi.ministry_role_id
        end
        mis_to_end << mi.id

        # finish mis
        if mis_to_end.length > 100
          MinistryInvolvement.connection.execute "UPDATE ministry_involvements set end_date = '#{Date.today.strftime("%Y-%m-%d")}' where id in (#{mis_to_end.join(',')})" 
          mis_to_end.clear
        end
       
      end
    end
  end

  def self.move_groups
    for g in @c4c.groups
      if g.campus
        puts "[group] #{g.name}"
        mc = MinistryCampus.find_all_by_campus_id(g.campus.id).last
        g.ministry = mc.ministry
        g.save!
      end
    end
  end
end
