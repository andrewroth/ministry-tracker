# Has children EmergencyAddress and PermanentAddress and CurrentAddress
class Address < ActiveRecord::Base
  load_mappings
  belongs_to :person, :class_name => "Person", :foreign_key => _(:person_id)

  # validates_presence_of _(:type), :message => "can't be blank"
  
  # Returns a string coontaining multiline mailing address
  def mailing
    out = address1.to_s 
    out += "<br />" unless out.strip.empty? || address2.to_s.empty?
    out += address2.to_s
    out += "<br />" unless out.strip.empty?
    out += city.to_s 
    out += ", " if city.present? && state.present?
    out += state if state.present?
    out += " " + zip.to_s
    out += "<br />" unless out.strip.empty? || !country.present?
    out += country if country.present?
    out
  end

  def mailing_one_line
    line = mailing.sub('<br />', ', ').strip
    return line[0..-2] if line.last == ','
    return line
  end

  # liquid method
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
  
  # i18n format
  def start_date=(value)
    if value.is_a?(String) && !value.blank?
      self[:start_date] = Date.strptime(value, (I18n.t 'date.formats.default'))
    else
      self[:start_date] = value
    end
  end

  def end_date=(value)
    if value.is_a?(String) && !value.blank?
      self[:end_date] = Date.strptime(value, (I18n.t 'date.formats.default'))
    else
      self[:end_date] = value
    end
  end
end
