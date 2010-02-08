{
  :'en-AU' => {
    # General stuff
    :app_name => 'Pulse',
    :staff => 'missionary',
    :staff_member => 'missionary',
    :staff_member_plural => 'missionaries',
    :Staff_Member => 'Missionary',
    :Staff_Member_plural => 'Missionaries',
    :staff_plural => 'missionaries',
    :Staff => 'Missionary',
    :Staff_plural => 'Missionaries',
    :zip => 'post code',
    :zip_plural => 'post codes',
    :Zip => 'Post Code',
    :Zip_plural => 'Post Codes',
    # Date and Time Formats
    :date => {
      :formats => {
        :default      => "%d/%m/%Y",
        :short        => "%e %b",
        :long         => "%e %B, %Y",
        :long_ordinal => lambda { |date| "#{date.day.ordinalize} %B, %Y" },
        :short_ordinal => lambda { |date| "#{date.day.ordinalize} %B" },
        :only_day     => "%e"
      },
      :day_names => Date::DAYNAMES,
      :abbr_day_names => Date::ABBR_DAYNAMES,
      :month_names => Date::MONTHNAMES,
      :abbr_month_names => Date::ABBR_MONTHNAMES,
      :order => [:day, :month, :year]
    },
    :time => {
      :day_names => Date::DAYNAMES,
      :abbr_day_names => Date::ABBR_DAYNAMES,
      :month_names => Date::MONTHNAMES,
      :abbr_month_names => Date::ABBR_MONTHNAMES,
      :formats => {
        :default      => "%a %b %d %H:%M:%S %Z %Y",
        :time         => "%H:%M",
        :short        => "%d %b %H:%M",
        :long         => "%d %B, %Y %H:%M",
        :long_ordinal => lambda { |time| "#{time.day.ordinalize} %B, %Y %H:%M" },
        :short_ordinal => lambda { |time| "#{time.day.ordinalize} %B" },
        :only_second  => "%S"
      },
      :datetime => {
        :formats => {
          :default => "%Y-%m-%dT%H:%M:%S%Z"
        }
      },
      :time_with_zone => {
        :formats => {
          :default => lambda { |time| "%Y-%m-%d %H:%M:%S #{time.formatted_offset(false, 'UTC')}" }
        }
      },
      :am => 'am',
      :pm => 'pm'
    },
    :datetime => {
      :distance_in_words => {
        :half_a_minute       => 'half a minute',
        :less_than_x_seconds => {:zero => 'less than a second', :one => 'less than a second', :other => 'less than {{count}} seconds'},
        :x_seconds           => {:one => '1 second', :other => '{{count}} seconds'},
        :less_than_x_minutes => {:zero => 'less than a minute', :one => 'less than a minute', :other => 'less than {{count}} minutes'},
        :x_minutes           => {:one => "1 minute", :other => "{{count}} minutes"},
        :about_x_hours       => {:one => 'about 1 hour', :other => 'about {{count}} hours'},
        :x_days              => {:one => '1 day', :other => '{{count}} days'},
        :about_x_months      => {:one => 'about 1 month', :other => 'about {{count}} months'},
        :x_months            => {:one => '1 month', :other => '{{count}} months'},
        :about_x_years       => {:one => 'about 1 year', :other => 'about {{count}} years'},
        :over_x_years        => {:one => 'over 1 year', :other => 'over {{count}} years'}
      }
    },
    :number => {
      :format => {
        :precision => 2,
        :separator => ',',
        :delimiter => '.'
      },
      :currency => {
        :format => {
          :unit => 'AUD',
          :precision => 2,
          :format => '%n %u'
        }
      }
    },

    # Active Record
    :activerecord => {
      :errors => {
        :template => {
          :header => {
            :one => "Couldn't save this {{model}}: 1 error",
            :other => "Couldn't save this {{model}}: {{count}} errors."
          },
          :body => "Please check the following fields:"
        },
        :messages => {
          :inclusion => "is not included in the list",
          :exclusion => "is not available",
          :invalid => "is not valid",
          :confirmation => "don't match its confirmation",
          :accepted  => "must be accepted",
          :empty => "must not be empty",
          :blank => "must not be blank",
          :too_long => "is too long (must be less than {{count}} characters)",
          :too_short => "is too short (must be greater than {{count}} characters)",
          :wrong_length => "is not the right length (must be {{count}} characters)",
          :taken => "is not available",
          :not_a_number => "is not a number",
          :greater_than => "must be greater than {{count}}",
          :greater_than_or_equal_to => "must be greater than or equal to {{count}}",
          :equal_to => "must be equal to {{count}}",
          :less_than => "must be less than {{count}}",
          :less_than_or_equal_to => "must be less than or equal to {{count}}",
          :odd => "must be odd",
          :even => "must be even"
        }
      }
    }
  }
}