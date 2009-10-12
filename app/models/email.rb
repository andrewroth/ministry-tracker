class Email < ActiveRecord::Base
  belongs_to :sender, :class_name => "Person", :foreign_key => "sender_id"
  belongs_to :search, :class_name => "Search", :foreign_key => "search_id"
  validates_presence_of :subject, :salutation, :body, :sender_id
  
  after_create :queue_email
  
  
  def send_email
    missing = []
    if search
      ids = ActiveRecord::Base.connection.select_values("SELECT distinct(Person.#{_(:id, :person)}) FROM #{Person.table_name} as Person #{search.table_clause} WHERE #{search.query}")
      @people = Person.find(ids)
    else
      @people = Person.find(JSON::Parser.new(people_ids).parse)
    end
    @people.each do |person|
      if person.primary_email.present?
        EmailMailer.deliver_email(person, self)
      else
        missing << person
      end
    end
    EmailMailer.deliver_report(self, missing)
    self.missing_address_ids = missing.collect(&:id).to_json
  end
  private
  def queue_email
    self.send_later(:send_email)
  end
end
