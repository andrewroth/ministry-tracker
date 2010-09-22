module PersonForm
  def setup_campuses
    @primary_campus_involvement ||= @person.primary_campus_involvement || CampusInvolvement.new
    # If the Country is set in config, don't filter by states but get campuses from the country
    if Cmt::CONFIG[:campus_scope_country] &&
      (c = Country.find(:first, :conditions => { _(:country, :country) => Cmt::CONFIG[:campus_scope_country] }))
      @no_campus_scope = true
      @campus_country = c
      @campuses = CmtGeo.campuses_for_country(c.code).sort{ |c1, c2| c1.name <=> c2.name }
      mc_cs = MinistryCampus.all(:select => :campus_id).collect(&:campus_id) # only campuses with a ministry team are valid
      @campuses = @campuses.find_all{ |c| mc_cs.include?(c.id) }
    else
      if @person.try(:primary_campus).try(:state).present? && @person.primary_campus.try(:country).present?
        @campus_state = @person.primary_campus.state
        @campus_country = @person.primary_campus.country
      elsif @person.current_address.try(:state).present? && @person.current_address.try(:country).present?
        @campus_state = @person.current_address.state
        @campus_country = @person.current_address.country
      elsif @person.try(:permanent_address).try(:state).present? && @person.permanent_address.try(:country).present?
        @campus_state = @person.permanent_address.state
        @campus_country = @person.permanent_address.country
      end
      @campus_states = CmtGeo.states_for_country(@campus_country) || []
      @campuses = CmtGeo.campuses_for_state(@campus_state, @campus_country) || []
    end
    @campus_countries = CmtGeo.all_countries
  end

  def get_campus_states
    @campus_country = params[:primary_campus_country]
    render :text => '' unless @campus_country.present?
    @campus_states = CmtGeo.states_for_country(@campus_country) || []
  end

  def get_campuses_for_state
    @campus_state = params[:primary_campus_state]
    @campus_country = params[:primary_campus_country]
    render :text => '' unless @campus_state
    @campuses = CmtGeo.campuses_for_state(@campus_state, @campus_country) || []
  end
end
