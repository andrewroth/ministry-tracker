class DelayedCorrespondence
  attr_reader :correspondence_id, :person_id, :params, :resend_if_not_acknowledged, :resend_delay,
    :resend_count

  # Each notification has a Correspondence model created to track whether the
  # notification was acknowledged.
  #
  # == Params
  #
  # [:person_id]
  #   Required.
  #   Person this correspondence is being sent to.
  # [:params]
  #   Required.
  #   Any params that give info about this correspondence.  Will be passed
  #   to the model on deliver and any callbacks.
  # [:resend_if_not_acknowledged]
  #   True if you want the notification to keep sending itself until the model's
  #   acknowledged flag to be true.
  #   Defaults to true.
  # [:resent_delay]
  #   Seconds to wait until resending, ignored unless resend_if_not_acknowledged is true
  #   Defaults to 24 hours.
  #   You can use ###.unit, like 10.hours
  # [:resend_count]
  #   Number of times to retry before giving up.
  #   Defaults to 3.
  # 
  # == Callbacks
  #
  # The deliver method on the model is called with @params plus the 
  # instance variables merged in, so that they can be sent to the template
  # if desired (ex "This is your second notification")
  #
  # If the model implements the methods "ack", "retry", or "giveup", 
  # expecting one hash parameter, it will be called with the @params
  # passed in.
  #
  def initialize(params = {})

    # defaults
    params = {
      :resend_if_not_acknowledged => true,
      :resend_delay => 24.hours,
      :resend_count => 3,
      :params => { }
    }.merge(params)

    # extract params
    @person_id = params.delete :person_id
    throw "DelayedNotification requires person_id" unless @person_id
    @params = params.delete :params
    throw "DelayedNotification requires params" unless @params
    @resend_if_not_acknowledged = params.delete :resend_if_not_acknowledged
    @resent_delay = params.delete :resend_delay
    @giveup_callback = params.delete :giveup_callback
    @resend_count = params.delete :resend_count

    @correspondence_id = Correspondence.create! :person_id => @person_id
  end

  # called by delayed_job
  def perform
    if @resend_if_not_acknowledged && correspondence.acknowledged
      callback_success
      return
    end

    if @resend_if_not_acknowledged && @resend_count >= 0 
      @resend_count -= 1
      reschedule
    else
      callback_failure
      return
    end

    correspondence.deliver(@params.merge(instance_variables_hash))

    if !@resend_if_not_acknowledged
      correspondence.destroy
    end
  end

  protected

  def reschedule
    # TODO
  end

  def instance_variables_hash() instance_variables.collect{ |v| instance_variable_get(v) } end

  def correspondence() Correspondence.find(@correspondence_id) end
end
