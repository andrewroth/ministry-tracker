class GlobalDashboardController < ApplicationController
  def index
    @genders = { "male" => 0, "female" => 0, "" => 0 }
    @profiles = GlobalProfile.all
    @profiles.each do |profile|
      @profiles[profile.gender] += 1
    end
  end
end
