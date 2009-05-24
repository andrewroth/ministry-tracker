class CorrespondenceNightly < Correspondence
  # [:person]
  #   The person to receive the notification
  # [:params]
  #   Params that will be passed to the once, ack, retry, giveup callbacks.
  def self.create_delayed(person_id, params)
    c = Correspondence.create! :person_id => person_id, :params => params
    next_3_am = Time.now.hour > 3 ? Time.now.tomorrow.utc : Time.now.utc
    next_3_am = Time.utc(next_3_am.year, next_3_am.month, next_3_am.day, 3)
    Delayed::Job.enqueue c, 0, next_3_am
  end
end
