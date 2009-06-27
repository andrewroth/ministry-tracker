# Has children EmergencyAddress and PermanentAddress and CurrentAddress
class Address < ActiveRecord::Base
  load_mappings
  belongs_to :person, :class_name => "Person", :foreign_key => _(:person_id)
  index _(:id) if $cache
  index [ _(:address_type), _(:person_id)] if $cache
  # validates_presence_of _(:type), :message => "can't be blank"
  
  # Returns a string coontaining multiline mailing address
  def mailing
    out = address1.to_s 
    out += "<br />" unless out.strip.empty? || address2.to_s.empty?
    out += address2.to_s
    out += "<br />" unless out.strip.empty?
    out += city.to_s 
    out += ", "  unless city.to_s.empty?
    out += state.to_s + " " + zip.to_s
  end
  
  # Called by state_id
  def state_obj
    State.find :first, :conditions => [ 
      "#{State.table_name}.#{_(:name, :state)} = ? OR #{State.table_name}.#{_(:abbreviation, :state)} = ?", 
      state, state
    ]
  end

  # Question: Unsure
  def state_id
    state_obj.try(:id)
  end

  # returns mailing address as one line seperated by commas
  def mailing_one_line
    line = mailing.sub('<br />', ', ').strip
    return line[0..-2] if line.last == ','
    return line
  end

  # liquid method
  def to_liquid
    { "email" => email, "phone" => phone }
  end
end
