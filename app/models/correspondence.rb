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
# If the model implements the methods "ack", "retry", or "giveup", 
# they will also be called
#
#
class Correspondence < ActiveRecord::Base
  belongs_to :person
  validates_presence_of :person
  
  attr_reader :callback_tried # for testing

  # sends a notification to the user this notification is to
  def deliver
    last_sent_at = Time.now
    save!
  end

  def reschedule
    Delayed::Job.enqueue self, 0, resend_delay
  end

  # called by delayed_job
  # delivers the notification and updates the status, and reschedules if necessary
  def perform
    if resend_if_not_acknowledged && acknowledged
      send_callback :ack
      return
    end

    if resend_if_not_acknowledged && resend_count >= 0
      self.resend_count -= 1
      save!
      send_callback :retry
      reschedule
    elsif resend_if_not_acknowledged
      send_callback :giveup
      return
    else
      send_callback :once
    end

    deliver
  end

  protected

  def pull_params() params.class == Hash ? params : YAML.load(params) end

  def send_callback(m)
    @callback_tried = m # for testing
    self.send(m, pull_params) if self.respond_to?(m)
  end
end
