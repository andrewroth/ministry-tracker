class Contact < ActiveRecord::Base  
  has_and_belongs_to_many :people
  belongs_to :campus
  has_many :notes, :as => :noteable
  has_many :activities, :as => :reportable

  NEXT_STEP_OPTIONS = [["Unknown", 0], ["Know and trust a Christian", 1], ["Become curious", 2], ["Become open to change", 3], ["Seek God", 4], ["Make a descision", 5], ["Grow in relationship with God", 6]]

  named_scope :active, :conditions => { :active => true }
  named_scope :with_campus_id, lambda { |campus_id| { :conditions => { :campus_id => campus_id } } }

  def full_name
    "#{first_name} #{last_name}"
  end
end