{
  :'en-US' => {
    :date => {
      :formats => {
        :long_ordinal => lambda { |date| "%B #{date.day.ordinalize}, %Y" },
        :short_ordinal => lambda { |date| "%B #{date.day.ordinalize}" }
      },
      :day_names => Date::DAYNAMES,
      :abbr_day_names => Date::ABBR_DAYNAMES,
      :month_names => Date::MONTHNAMES,
      :abbr_month_names => Date::ABBR_MONTHNAMES
    },
    :time => {
      :formats => {
        :long_ordinal => lambda { |time| "%B #{time.day.ordinalize}, %Y %H:%M" },
        :short_ordinal => lambda { |time| "%B #{time.day.ordinalize}" }
      },
      :time_with_zone => {
        :formats => {
          :default => lambda { |time| "%Y-%m-%d %H:%M:%S #{time.formatted_offset(false, 'UTC')}" }
        }
      }
    }
  }
}