class Address < ActiveRecord::Base
  load_mappings
  belongs_to :person, :class_name => "Person", :foreign_key => _(:person_id)
  index _(:id) if $cache
  index [ _(:address_type), _(:person_id)] if $cache

  # validates_presence_of _(:type), :message => "can't be blank"
  
  def mailing
    out = address1.to_s 
    out += "<br />" unless out.strip.empty? || address2.to_s.empty?
    out += address2.to_s
    out += "<br />" unless out.strip.empty?
    out += city.to_s 
    out += ", " if city.present? && state.present?
    out += state
    out += " " + zip.to_s
  end

  def mailing_one_line
    line = mailing.sub('<br />', ', ').strip
    return line[0..-2] if line.last == ','
    return line
  end

  #liquid_methods
  def to_liquid
    { "email" => email, "phone" => phone }
  end

  def sanify
    # make sure that if there is a state, there is also a country
    if self.state.present? && !country.present?
      self.state = country = nil
      save!
    end
  end
end
