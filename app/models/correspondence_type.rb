# The types of correspondences possible
class CorrespondenceType < ActiveRecord::Base
  has_many :email_templates
  has_many :correspondences
  serialize :redirect_params

  validates_presence_of _(:name)
  validates_presence_of _(:overdue_lifespan)
  validates_presence_of _(:expiry_lifespan)

  # returns a hash of the redirect_params datafield
  # Question: Incomplete?
  def redirect_params_hash

  end

  def redirect_params=(params)

    # params should be a hash

    params_hash = Hash.new
    params.each do |key,param|
      params_hash.store(param["name"].to_s, param["value"].to_s) if (!param["name"].empty?)
    end
    self[:redirect_params] = params_hash
  end

  # Question: Called by?
  def get_available_outcomes
    return ["NOW", "OVERDUE"]
  end
end
