# A correspondence is essentially a tracked email sent out to 
# a person.  Correspondences should never be made manually,
# insead use the CorrespondenceSubclass.create_delayed
# which will use delayed_job to make a DelayedCorrespondence, which
# will then make one of these.
#
class Correspondence < ActiveRecord::Base
  belongs_to :person

  # sends a notification to the user this notification is to
  def deliver(template, params)
    logger.info "Deliver #{self.class.name} rendering template #{template} with params #{params}"
    last_sent_at = Time.now
    save!
  end

  def get_redirect_url
    "/#{success_controller}/#{success_action}"
  end
end
