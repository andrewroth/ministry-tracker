# A correspondence is essentially a tracked email sent out to 
# a person.  This class is intended to be extended by subclasses
# that implement a create_delayed and the various hooks.
#
# If this class is instantiated, it will assume the params
# value was a hash with values :template, :template_params,
# and :subject, which will be used when rendering the email.
#
# == Hooks
#
# Extending models must implement the deliver method.
#
# If the model implements the methods "delivered", "acked", or "gaveup", 
# they will also be called on the next execution.  Delivered callback
# is called any time the email is sent, acked callback is sent when
# a user acknowledges the correpsondence (note this callback is
# delayed until the next job run) and gaveup is sent when the
# retry limit is reached.
#
class Correspondence < ActiveRecord::Base
  belongs_to :person
  validates_presence_of :person
  belongs_to :delayed_job, :class_name => 'Delayed::Job'
  
  before_destroy :finish_job

  attr_reader :callback_tried # for testing

  # sends a notification to the user this notification is to
  def deliver
    last_sent_at = Time.now
    save!
  end

  # called by delayed_job
  # delivers the notification and updates the status, and reschedules if necessary
  def perform
    if recurring && acknowledged
      send_callback :acked
      destroy
      return
    end

    if recurring && !has_resends_left?
      send_callback :gaveup
      destroy
      return
    end

    send_callback :delivered
    deliver
  end

  def recurring() delayed_job.recur end

  def pull_params() params.class == Hash ? params : YAML.load(params) end

  def has_resends_left?() delayed_job.executions_left > 0 end

  protected

  def finish_job
    delayed_job.recur = false # cause the job to terminate right after the perform method
    delayed_job.save!
  end

  def send_callback(m)
    @callback_tried = m # for testing
    self.send(m, pull_params) if self.respond_to?(m)
  end
end
