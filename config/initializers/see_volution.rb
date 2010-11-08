if RAILS_ENV == "production"
  $see_volution = (defined?(Common::SEE_VOLUTION) ? Common::SEE_VOLUTION : "")
else
  $see_volution = ""
end
