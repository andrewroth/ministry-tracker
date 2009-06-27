class Correspondence < ActiveRecord::Base
  # define constants for lifecycle
  State_Unsent = 0
  State_Sent = 10
  State_OverdueSent = 20
  State_Completed = 30

  belongs_to :correspondence_type
  belongs_to :person

  serialize :token_params

  validates_presence_of _(:correspondence_type_id)
  validates_presence_of _(:person_id)
  validates_presence_of _(:receipt)

  
  # GET /correspondences/processQueue
  # sends unsent correspondences in the queue and executes any overdue correspondences
  def self.processQueue
    # iterate and process unsent correspondences
    correspondences = Correspondence.find(:all, :joins => { :correspondence_type, :email_templates }, :conditions => ["email_templates.outcome_type = 'NOW' and state = ?", State_Unsent])
    correspondences.each do |correspondence|
      correspondence.initiate('NOW')
    end

    # find and iterate through overdue correspondences
    correspondences = Correspondence.find(:all, :joins => { :correspondence_type, :email_templates }, :conditions => ["email_templates.outcome_type = 'OVERDUE' and state >= ? and state < ? and curdate() > overdue_at", State_Sent, State_OverdueSent])
    correspondences.each do |correspondence|
      correspondence.initiate('OVERDUE')
    end
  end


  # initiate a correspondence
  def initiate(outcomeType)
    person = Person.find(person_id, :include => :current_address )

    email_template = EmailTemplate.find(:first, :conditions => { :correspondence_type_id => correspondence_type.id, :outcome_type => outcomeType})

    # create an array of param objects

    template_params = { :recipient => person, :receipt => receipt }
    #template_params.store(:rcpt_uri, ActionView::Helpers::UrlHelper.url_for(:id => correspondence.receipt, :action => 'rcpt', :controller => 'correspondence'))
    token_params.each do |key, value|
      klass =  value[:class]

      # determine token type
      if value[:type] == 'record'
        id = value[:id]
        paramObj = Object.const_get(klass).find(id)
        template_params[:key] = paramObj
      else
        template_params.store(key, value[:contents])
        template_params[:key] = value[:contents]
      end
      
      
    end
    email_template.deliver_to(person.current_address.email, template_params)

    # run 'observers'
    executeDefinedActions(outcomeType)
      

    # change state of correspondence
    if (state.to_i == State_Unsent)
      Correspondence.update(id, { :state => State_Sent })
    elsif (outcomeType == 'OVERDUE')
      Correspondence.update(id, { :state => State_OverdueSent })
    end

  end


  # register a new correspondence
  def self.register(correspondenceTypeName, person, hTokenObj)
    # create new correspondence object
    correspondence = Correspondence.new

    # get correspondence type details
    correspondence_type = CorrespondenceType.find(:first, :conditions => ["name = ?", correspondenceTypeName])

    if correspondence_type and !person.nil?
      # get information on the given objects and get it ready for db storage
      tokenParams = Hash.new()
      hTokenObj.each do |key, tokenObj|
        token_class_name = tokenObj.class.to_s

        # check if this is an ActiveRecord object
        if tokenObj.kind_of? ActiveRecord::Base
          token_data = {:class => token_class_name, :id => tokenObj.id, :type => 'record'}
          tokenParams.store(key, token_data)
        else
          token_data = {:class => token_class_name, :contents => tokenObj, :type => 'datastore'}
          tokenParams.store(key, token_data)
        end
      end

      # fill data fields
      correspondence.receipt = self.generateReceipt
      correspondence.correspondence_type_id = correspondence_type.id
      correspondence.person_id = person.id
      correspondence.state = State_Unsent
      correspondence.overdue_at = (Date.today+correspondence_type.overdue_lifespan.to_i).strftime('%Y-%m-%d')
      # TODO: Should rename expiry_lifespan to expiration
      correspondence.expire_at = (Date.today+correspondence_type.expiry_lifespan.to_i).strftime('%Y-%m-%d')
      correspondence.token_params = tokenParams
      correspondence.save
      receipt_id = correspondence.receipt
    end
  end

  def record_visit
    Correspondence.update(id, { :visited => (Date.today).strftime('%Y-%m-%d') })
  end

  def redirect_params
    redirect_params = correspondence_type.redirect_params

    # add token params as well that are activerecords
    token_params.each do |key, value|
      # determine token type
      if value[:type] == 'record'
        if key.to_s === correspondence_type.redirect_target_id_type
          redirect_params.store(:id, value[:id])
        else
          redirect_params.store(key, value[:id])
        end
      end
    end

    # by default, set receipient person_id as :id
    redirect_params[:id] = person_id if redirect_params[:id].nil?

    return redirect_params
  end

  # Called externally, when the correspondence has been actioned
  def correspondenceCompleted
    # update record
    Correspondence.update(id, { :state => State_Completed, :completed => (Date.today).strftime('%Y-%m-%d'), :receipt => "" })

    # execute any followup actions
    executeDefinedActions('FOLLOWUP')
  end


  def get_state
    case state.to_i
    when State_Unsent
      return "Unsent"
    when State_Sent
      return "Sent"
    when State_OverdueSent
      return "Overdue"
    when State_Completed
      return "Completed"
    end
    return "Unknown"
  end

  
  
  # This is probably the wrong place to put it, probably should go into a View helper I think.
  def token_params_html
    output = String.new
    token_params.each do |key, token|
      if (token[:type] == 'record')
        output += "<strong>ActiveRecord #{token[:class]}:</strong> #{key} <strong>id: </strong>#{token[:id]}<br/>"
      else
        output += "<strong>Datastore of type #{token[:class]}: </strong>#{key} <strong>Raw contents: </strong>#{token[:contents].to_yaml}"
      end
    end
    return output
  end

  def executeDefinedActions(outcomeType)

  end

  # Generate a semi-random but always unique 10 letter code.
  def self.generateReceipt
    curTime = Time.new
    pseudoRandomBigNum = curTime.to_i + rand(9) + rand(9) + rand(9)
    receipt = (Digest::SHA256.hexdigest(pseudoRandomBigNum.to_s)).slice(0,10)
  end
end
