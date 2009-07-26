# Question: Seems to create custom attributes, whatever they are.
#
# Has involvement_questions as a child class

class CustomAttributesController < ApplicationController
  before_filter :get_custom_attribute, :only => ['edit','update','destroy']
  before_filter :ensure_permission_based_on_type, :except => [ :index ]

  layout 'manage'
  
  def index
  end
  
  def new
    @custom_attribute = CustomAttribute.new
    @custom_attribute.ministry_id = @ministry.id
  end
  
  def edit
    @custom_attribute = CustomAttribute.find(params[:id])
    @type = @custom_attribute.type.to_s
    respond_to do |format|
      format.js 
    end
  end
  
  def create
    @custom_attribute = params[:type].constantize.new(params[:custom_attribute])
    @custom_attribute.ministry = @ministry
    # @attributes = @ministry.send(params[:type].underscore.pluralize)
    respond_to do |format|
      if @custom_attribute.save
        flash[:notice] = @custom_attribute.name + ' was successfully created.'
        format.html { redirect_to custom_attributes_url }
        format.js   
        format.xml  { head :created, :location => custom_attributes_url(@custom_attribute) }
      else
        format.html { render :action => "new" }
        format.js   { render :action => "new" }
        format.xml  { render :xml => @custom_attribute.errors.to_xml }
      end
    end
  end
  
  def update
    @custom_attribute.update_attributes(params[@custom_attribute.type.to_s.underscore])
    respond_to do |format|
      format.js { render :template => 'custom_attributes/update' }
    end
  end

  def destroy
    @custom_attribute.destroy 
    flash[:notice] = @custom_attribute.name + ' was successfully DELETED.'
    respond_to do |format|
      format.js 
    end
  end
  
  protected
    def get_custom_attribute
      @custom_attribute = CustomAttribute.find(params[:id])
    end

    def ensure_permission_based_on_type
      params[:type] ||= @custom_attribute.class.name

      if params[:type].nil? || params[:type].empty?
        flash[:notice] = "Type required"
        @no_permission = true
        render
        return
      end

      unless authorized?(:new, params[:type].underscore.pluralize)
        flash[:notice] = "You don't have permission to create that type of custom attribute."
        @no_permission = true
        render
        return
      end
    end
end
