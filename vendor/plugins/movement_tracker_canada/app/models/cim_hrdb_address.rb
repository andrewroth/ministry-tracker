#class CimHrdbAddress < Address
class CimHrdbAddress < ActiveRecord::Base
  self.abstract_class = true

  belongs_to :province, :class_name => 'State'
  belongs_to :country
  belongs_to :title_bt, :class_name => 'Title', :foreign_key => :title_id
  has_one :person_extra_ref, :class_name => 'PersonExtra', 
    :foreign_key => 'person_id'

  def person_extra()
    @person_extra ||= person_extra_ref || PersonExtra.new(:person_id => id)
  end

  def state
    province ? province.name : ''
  end

  def state=(v)
    throw "not implemented"
  end

  def country
    province && province.country ? province.country.name : ''
  end

  def title
    title_bt ? title_bt.desc : ''
  end

  def province=(val) throw 'not implemented' end
  def country=(val) throw 'not implemented' end
    
  def mailing
    out = address1.to_s 
    out += "<br />" unless out.strip.empty?
    out += city.to_s 
    out += ", "  unless city.to_s.empty?
    out += state.to_s + " " + zip.to_s
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
end
