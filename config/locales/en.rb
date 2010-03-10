{
  :'en' => {
    :app_name => "Campus Movement Tracker",
    :analytics => "<script type=\"text/javascript\">
      var gaJsHost = ((\"https:\" == document.location.protocol) ? \"https://ssl.\" : \"http://www.\");
      document.write(unescape(\"%3Cscript src=\' \" + gaJsHost + \"google-analytics.com/ga.js\' type=\'text/javascript\'%3E%3C/script%3E\"));
      </script>
      <script type=\"text/javascript\">
      var pageTracker = _gat._getTracker(\"UA-79392-17\");
      pageTracker._initData();
      pageTracker._trackPageview();
    </script>" +
    '<!-- Woopra Code Start -->
    <script type="text/javascript" src="//static.woopra.com/js/woopra.v2.js"></script>
    <script type="text/javascript">
    woopraTracker.track();
    </script>
    <!-- Woopra Code End -->',
    :date => {
      :formats => {
        :default => "%m/%d/%Y",
        :short => "%e %b",
        :long => "%B %e, %Y",
        :only_day => "%e",
        :long_ordinal => lambda { |date| "%B #{date.day.ordinalize}, %Y" },
        :short_ordinal => lambda { |date| "%B #{date.day.ordinalize}" },    
      },
      :order => [ :year, :month, :day ],
      :day_names => Date::DAYNAMES,
      :abbr_day_names => Date::ABBR_DAYNAMES,
      :month_names => Date::MONTHNAMES,
      :abbr_month_names => Date::ABBR_MONTHNAMES
    },
    :time => {
      :day_names => Date::DAYNAMES,
      :abbr_day_names => Date::ABBR_DAYNAMES,
      :month_names => Date::MONTHNAMES,
      :abbr_month_names => Date::ABBR_MONTHNAMES,
      :formats => {
        :default => "%a %b %d %H:%M:%S %Z %Y",
        :time => "%l:%M %p",
        :short => "%d %b %H:%M",
        :long => "%B %d, %Y %H:%M",
        :only_second => "%S",
        :long_ordinal => lambda { |time| "%B #{time.day.ordinalize}, %Y %H:%M" },
        :short_ordinal => lambda { |time| "%B #{time.day.ordinalize}" }
      },
      :time_with_zone => {
        :formats => {
          :default => lambda { |time| "%Y-%m-%d %H:%M:%S #{time.formatted_offset(false, 'UTC')}" }
        }
      },
      :datetime => {
        :formats => {
          :default => "%Y-%m-%dT%H:%M:%S%Z",
        }
      },
      :am => 'am',
      :pm => 'pm'
    },
    :activerecord => {
      :errors => {
        :messages => {
          :inclusion => "is not included in the list",
          :exclusion => "is reserved",
          :invalid => "is invalid",
          :confirmation => "doesn't match confirmation",
          :accepted => "must be accepted",
          :empty => "can't be empty",
          :blank => "can't be blank",
          :too_long => "is too long (maximum is {{count}} characters)",
          :too_short => "is too short (minimum is {{count}} characters)",
          :wrong_length => "is the wrong length (should be {{count}} characters)",
          :taken => "has already been taken",
          :not_a_number => "is not a number",
          :greater_than => "must be greater than {{count}}",
          :greater_than_or_equal_to => "must be greater than or equal to {{count}}",
          :equal_to => "must be equal to {{count}}",
          :less_than => "must be less than {{count}}",
          :less_than_or_equal_to => "must be less than or equal to {{count}}",
          :odd => "must be odd",
          :even => "must be even",
        },
        :template => {
          :header => {
            :one => "1 error prohibited this {{model}} from being saved",
            :other => "{{count}} errors prohibited this {{model}} from being saved"
          },
          :body => "There were problems with the following fields:"
        }
      }
    }
  }
}
      
  
