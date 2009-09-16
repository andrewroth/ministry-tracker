# Question: purpose?
class StaffController < PeopleController
  # before_filter :ministry_admin_filter, :only => [:demote, :demote_form]
  
  layout 'manage'
  
  def index
    @staff = @ministry.staff
  end
  
  def search_to_add
    if params[:search].present?
      search = params[:search].to_s.strip
      # search = '%' if search.empty?
      case true
      when !search.scan(' ').empty?
        names = search.split(' ')
        first = names[0].strip
    		last = names[1..-1].join(' ').strip
      	conditions = ["(#{_(:last_name, :person)} LIKE ? AND #{_(:first_name, :person)} LIKE ?)", 
      	              "#{quote_string(last)}%", "#{quote_string(first)}%"] 
      when !search.scan('@').empty?
        conditions = ["#{CurrentAddress.table_name}.#{_(:email, :address)} LIKE ?", "#{quote_string(search)}%"]
      else
        if search.present?
          conditions = ["(#{_(:last_name, :person)} LIKE ? OR #{_(:first_name, :person)} LIKE ?)", "#{quote_string(search)}%", "#{quote_string(search)}%"]
        end
      end
      @count = Person.count(:conditions => conditions, :include => :current_address)
      @results = Person.find(:all, :conditions => conditions, :include => :current_address, :limit => 20, :order => "#{_(:last_name, :person)}, #{_(:first_name, :person)}")
      render :update do |page|
        page[:results].replace_html :partial => 'staff/results', :results => @results
      end
    else
      render :nothing => true
    end
  end

  # def demote
  #   @person = Person.find(params[:id])
  #   # we have to have at least one campus for this person
  #   if params[:campus] || @person.campus_involvements.count > 0
  #     # also make sure they're not a staff person
  #     @mi = MinistryInvolvement.find_by_ministry_id_and_person_id(@ministry.id, @person.id) 
  #     @mi.destroy if @mi
  #     # create campus involvement
  #     @person.add_campus(params[:campus], @ministry.id, @me.id)
  #   end
  # end
  # 
  # def demote_form
  #   @staff = Person.find(params[:id])
  # end
  
end
