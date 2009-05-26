class CorrespondenceNightly < Correspondence
  # [:person]
  #   The person to receive the notification
  # [:params]
  #   Params that will be passed to the once, ack, retry, giveup callbacks.
  #
  # This correspondence will be resent three times before giving up.
  def self.create_delayed(person_id, params)
    next_3_am = Time.now.hour > 3 ? Time.now.tomorrow.utc : Time.now.utc
    next_3_am = Time.utc(next_3_am.year, next_3_am.month, next_3_am.day, 3)
    c = Correspondence.create! :person_id => person_id, :params => params
    dj = Delayed::Job.recurring c, 0, next_3_am, 24.hours, 4
    c.delayed_job = dj
    c.save!
    dj.payload_object = c # update since delayed_job has changed
    return c
  end
end
