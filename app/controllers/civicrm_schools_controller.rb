class CivicrmSchoolsController < ApplicationController
  include CiviCRM
  before_filter :get_school, :only => [:show, :edit] 

  def index
    begin
      connect = CiviCRM::API.new
      @schools = connect.get(:Contact, :with => { "contact_sub_type" => "School", 
        "return" => "display_name,custom_68,custom_69,custom_70,custom_71,custom_72,custom_73,custom_74" })
      @schools.sort! { |a,b| a.display_name.downcase <=> b.display_name.downcase }
      @totals = get_totals(@schools)
    rescue => e
      connect.log :error, e
    end
  end
  
  def show
  end

  def edit
  end

  def update
    begin
      # debugger
      [:custom_88, :custom_89, :custom_113, :custom_114].each do |link|
        if !params[:civicrm_schools][link].blank? && !(params[:civicrm_schools][link] =~ /http:\/\/(.*)/)
          params[:civicrm_schools][link] = "http://" + params[:civicrm_schools][link]
          debugger
        end
      end

      connect = CiviCRM::API.new
      response = connect.update(:Contact, :with => params[:civicrm_schools])
      response2 = connect.update(:Phone, :with => params[:phone])
      response3 = connect.create(:Address, :with => params[:address])
      # debugger
      if true
        flash[:notice] = "School Edit Successful!"
        redirect_to :action => :show
      else
        get_school
        @school.attributes.merge!(params[:civicrm_schools])
        render :edit
      end
    rescue CiviCRM::StandardError => e
      connect.log :error, e
      get_school
      @school.attributes.merge!(params[:civicrm_schools])
      @school.attributes.merge!(params[:phone])
      @school.attributes.merge!(params[:address])
      bad_values = e.message.scan(/value: (.+)\)/).flatten
      flash[:warning] = "Value \'#{bad_values[0]}\' is not valid"
      render :edit
    end
  end

  private
  def get_totals(schools)
    totals = {}
    totals[:num_schools] = 0
    totals[:slmq1] = 0
    totals[:slmq2] = 0
    totals[:slmq3] = 0
    totals[:isslm] = 0
    totals[:min_pres] = 0
    totals[:staffed] = 0
    totals[:expansion] = 0
    totals[:launch] = 0
    totals[:sponsor] = 0

    schools.each do |school|
      totals[:num_schools] += 1
      totals[:slmq1] += 1 if school.attr(:custom_68) == 'Yes'
      totals[:slmq2] += 1 if school.attr(:custom_69) == 'Yes'
      totals[:slmq3] += 1 if school.attr(:custom_70) == 'Yes'
      totals[:isslm] += 1 if school.attr(:custom_71) == 'Yes'
      totals[:min_pres] += 1 if school.attr(:custom_73) == 'Yes'
      totals[:staffed] += 1 if school.attr(:custom_72) == 'Staffed'
      totals[:expansion] += 1 if school.attr(:custom_72) == 'Expansion'
      totals[:launch] += 1 if school.attr(:custom_74) == 'Launch'
      totals[:sponsor] += 1 if school.attr(:custom_74) == 'Sponsor'
    end
    totals
  end

  def get_school
    begin
      connect = CiviCRM::API.new
      @school = connect.get(:Contact, :with => { :id => params[:id],
        "return" => "display_name,street_address,city,state_province,postal_code,country,phone,geo_code_1,"+
        "geo_code_2,custom_68,custom_69,custom_70,custom_71,custom_72,custom_73,custom_74,custom_84,custom_85,"+
        "custom_86,custom_88,custom_89,custom_90,custom_91,custom_92,custom_93,custom_94,custom_95,"+
        "custom_96,custom_97,custom_98,custom_99,custom_100,custom_101,custom_102,custom_103,custom_104,custom_105,"+
        "custom_106,custom_107,custom_108,custom_109,custom_110,custom_111,custom_112,custom_113,custom_114,phone_id,address_id" }).first
    rescue => e
      connect.log :error, e
    end
  end
end