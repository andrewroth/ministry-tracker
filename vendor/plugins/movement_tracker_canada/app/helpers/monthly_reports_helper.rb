module MonthlyReportsHelper
  unloadable
  
  SCHOOL_YEAR_OTHER_IDX = 9
  ALUMNI_ROLE_NAME = "Alumni"
  FROSH_YEAR_ID = 1
  ALUMNI_YEAR_ID = 10
  OTHER_YEAR_ID = 9
  STAT_INDEX_COUNT = 0
  STAT_INDEX_NAMES = 1
  AUTO_COLLECT_NUM_FROSH = "monthlyreport_numFrosh"
  AUTO_COLLECT_NUM_IN_DG = "monthlyreport_totalStudentInDG"
  AUTO_COLLECT_TOTAL_SP_MULT = "monthlyreport_totalSpMult"
  AUTO_COLLECT_STATS = [AUTO_COLLECT_NUM_FROSH, AUTO_COLLECT_NUM_IN_DG, AUTO_COLLECT_TOTAL_SP_MULT]
  
  SPIRITUAL_MULTIPLIER_LABEL_ID = Label.find_by_content("Spiritual Multiplier") != nil ? Label.find_by_content("Spiritual Multiplier").id : -1
  
  GROUP_TYPE_INDEX = 0
  GROUP_STAT_INDEX = 1

def auto_collect_stats
	@auto_collected_stats = Hash.new
  AUTO_COLLECT_STATS.each do |ac_stat|
    case ac_stat
    when AUTO_COLLECT_NUM_IN_DG
      @auto_collected_stats[ac_stat] = get_stat(AUTO_COLLECT_NUM_IN_DG)

    when AUTO_COLLECT_NUM_FROSH
      @auto_collected_stats[ac_stat] = get_stat(AUTO_COLLECT_NUM_FROSH)

    when AUTO_COLLECT_TOTAL_SP_MULT	
      @auto_collected_stats[ac_stat] = get_stat(AUTO_COLLECT_TOTAL_SP_MULT)
    end
  end
end

def get_stat(stat_to_collect)
  @collected_stat = []

  case stat_to_collect
  when AUTO_COLLECT_NUM_IN_DG	                 
    campus_id = @report.campus_id
    sid = Semester.current.id
    involved_in_dg = Person.find(:all,
                                 :select => "#{Person.__(:person_id)} as person_id, #{Person.__(:person_fname)} as First_Name, #{Person.__(:person_lname)} as Last_Name",
    :joins => "LEFT JOIN #{CampusInvolvement.table_name} ci ON ci.person_id = #{Person.table_name}.person_id and ci.end_date is NULL LEFT JOIN #{MinistryInvolvement.table_name} mi ON mi.person_id = #{Person.table_name}.person_id and mi.end_date is NULL LEFT JOIN #{GroupInvolvement.table_name} gi ON gi.person_id = #{Person.table_name}.person_id",
    :conditions => "ci.campus_id IN(#{campus_id}) and gi.group_id in (SELECT gps.id FROM #{Group.table_name} as gps WHERE gps.campus_id = #{campus_id} AND gps.semester_id = #{sid}) AND gi.level != 'interested'",
    :order => 'Last_Name ASC, First_Name ASC',
      :group => "#{Person.__(:person_id)}")		  

    #@collected_stat[STAT_INDEX_COUNT] =  involved_in_dg.count
    @collected_stat =  involved_in_dg		#[STAT_INDEX_NAMES]

  when AUTO_COLLECT_NUM_FROSH
    sid = Semester.current.id     
    campus_id = @report.campus_id
    # frosh_involved = Person.find(:all,
    #   :select => "#{Person.__(:person_id)} as person_id, #{Person.__(:person_fname)} as First_Name, #{Person.__(:person_lname)} as Last_Name",
    #   :joins => "LEFT JOIN #{CampusInvolvement.table_name} ci ON ci.person_id = #{Person.table_name}.person_id and ci.end_date is NULL LEFT JOIN #{MinistryInvolvement.table_name} mi ON mi.person_id = #{Person.table_name}.person_id and mi.end_date is NULL",
    #   :conditions => "school_year_id IN (#{FROSH_YEAR_ID}) AND ci.campus_id IN(#{campus_id})",
    #   :order => 'Last_Name ASC, First_Name ASC',
    #   :group => "#{Person.__(:person_id)}")		
    frosh_involved = Person.find(:all,
                                 :select => "#{Person.__(:person_id)} as person_id, #{Person.__(:person_fname)} as First_Name, #{Person.__(:person_lname)} as Last_Name",
    :joins => "LEFT JOIN #{CampusInvolvement.table_name} ci ON ci.person_id = #{Person.table_name}.person_id and ci.end_date is NULL LEFT JOIN #{MinistryInvolvement.table_name} mi ON mi.person_id = #{Person.table_name}.person_id and mi.end_date is NULL LEFT JOIN #{GroupInvolvement.table_name} gi ON gi.person_id = #{Person.table_name}.person_id",
    :conditions => "ci.school_year_id IN (#{FROSH_YEAR_ID}) AND ci.campus_id IN(#{campus_id}) and gi.group_id in (SELECT gps.id FROM #{Group.table_name} as gps WHERE gps.campus_id = #{campus_id} AND gps.semester_id = #{sid}) AND gi.level != 'interested'",
    :order => 'Last_Name ASC, First_Name ASC',
      :group => "#{Person.__(:person_id)}")		   

    #@collected_stat[STAT_INDEX_COUNT] =  frosh_involved.count
    @collected_stat =  frosh_involved		# [STAT_INDEX_NAMES]

  when AUTO_COLLECT_TOTAL_SP_MULT
    campus_id = @report.campus_id
    spiritual_multipliers = Person.find(:all,
                                        :select => "#{Person.__(:person_id)} as person_id, #{Person.__(:person_fname)} as First_Name, #{Person.__(:person_lname)} as Last_Name",
    :joins => "LEFT JOIN #{CampusInvolvement.table_name} ci ON ci.person_id = #{Person.table_name}.person_id and ci.end_date is NULL LEFT JOIN #{MinistryInvolvement.table_name} mi ON mi.person_id = #{Person.table_name}.person_id and mi.end_date is NULL LEFT JOIN #{LabelPerson.table_name} lbls ON lbls.person_id = #{Person.table_name}.person_id",
    :conditions => "ci.campus_id IN(#{campus_id}) AND lbls.label_id = #{SPIRITUAL_MULTIPLIER_LABEL_ID}",
    :order => 'Last_Name ASC, First_Name ASC',
      :group => "#{Person.__(:person_id)}")	

    @collected_stat =  spiritual_multipliers					

  end	# case statements

  @collected_stat

end

end
