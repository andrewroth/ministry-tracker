module Rbouncely
  
  class Bounce

    attr_reader :email, :bounced_at, :subject, :type, :message_id, :email_id
    
    def initialize(object)
      @email = object.at(:email).try(:inner_html)
      @bounced_at = Time.parse(object.at(:bouncedat).try(:inner_html))
      @subject = object.at(:subject).try(:inner_html)
      @type = object.at(:type).try(:inner_html)
      @message_id = object.at(:'message-id').try(:inner_html)
      @email_id = object.at(:email_id).try(:inner_html)
    end
  
  end
end
