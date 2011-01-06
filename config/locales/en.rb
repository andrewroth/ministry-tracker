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
  }
}
