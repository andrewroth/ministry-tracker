#class CimHrdbAddress < Address
class CimHrdbAddress < ActiveRecord::Base
  self.abstract_class = true

  belongs_to :title_bt, :class_name => 'Title', :foreign_key => :title_id
  has_one :person_extra_ref, :class_name => 'PersonExtra', 
    :foreign_key => 'person_id'

  def state
    @state_v || state_ref.try(:province_shortDesc)
  end

  def state=(v)
    @state_v = v
    self.state_ref = State.find(:first, :conditions => { :province_shortDesc => v })
    @state_v = nil if self.state_ref.nil?
  end

  def country
    @country_v || country_ref.try(:country_shortDesc)
  end

  def country=(v)
    @country_v = v
    self.country_ref = Country.find(:first, :conditions => { :country_shortDesc => v })
    @country_v = nil if self.country_ref.nil?
  end

  def person_extra()
    @person_extra ||= person_extra_ref || PersonExtra.new(:person_id => id)
  end

  def title
    title_bt ? title_bt.desc : ''
  end

  # Returns a string coontaining multiline mailing address
  def mailing
    out = address1.to_s
    out += "<br />" unless out.strip.empty? || address2.to_s.empty?
    out += address2.to_s
    out += "<br />" unless out.strip.empty?
    out += city.to_s
    out += ", " if city.present? && state.present?
    out += state if state.present?
    out += "<br />" + zip.to_s if zip.present?
    out += "<br />" unless out.strip.empty? || !country.present?
    out += country_ref.name
  end

  def start_date() person_extra.send("#{extra_prefix}_start_date") end
  def start_date=(v)
    person_extra.send("#{extra_prefix}_start_date=", v)
  end
  def end_date() person_extra.send("#{extra_prefix}_end_date") end
  def end_date=(v) person_extra.send("#{extra_prefix}_end_date=", v) end
  def alternate_phone() person_extra.send("#{extra_prefix}_alternate_phone") end
  def alternate_phone=(v) person_extra.send("#{extra_prefix}_alternate_phone=", v) end
  def dorm() person_extra.send("#{extra_prefix}_dorm") end
  def dorm=(v) person_extra.send("#{extra_prefix}_dorm=", v) end
  def room() person_extra.send("#{extra_prefix}_room") end
  def room=(v) person_extra.send("#{extra_prefix}_room=", v) end
  def after_save
    person_extra.save!
  end

  MockAggregation = Struct.new(:klass)
  def self.reflect_on_aggregation(name)
    if [:start_date, :end_date].include? name
      agg = MockAggregation.new
      agg.klass = Date
      return agg
    end
    super
  end

  def sanify
  end
end
