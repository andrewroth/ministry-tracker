{
  :'en-CA' => {
    # General stuff
    :state => 'province',
    :state_plural => 'provinces',
    :State => 'Province',
    :State_plural => 'Provinces',
    :zip => 'postal code',
    :zip_plural => 'postal codes',
    :Zip => 'Postal Code',
    :Zip_plural => 'Postal Codes',
    :Bible_Study => 'Discipleship Group',
    :bible_study => 'discipleship group',
    :Bible_Study_plural => 'Discipleship Groups',
    :bible_study_plural => 'discipleship groups',
    :Bible_Study_short => 'DG',
    :Bible_Study_short_plural => 'DGs',
    :app_name => 'Pulse',
    :slogan => "<img src='/images/conduitbanner.png'></img>",
    :help_link => "https://www.mygcx.org/Pulse_Help_Center/screen/home",
    :help_header => "Help",
    :alternate_phone => 'Cell Phone',
    
    :please_login => 'Sign In',
    :analytics => %|
<script type="text/javascript">
    var gaJsHost = (("https:" == document.location.protocol) ? "https://ssl." : "http://www.");
    document.write(unescape("%3Cscript src='" + gaJsHost + "google-analytics.com/ga.js' type='text/javascript'%3E%3C/script%3E"));
    </script>
    <script type="text/javascript">
    try {
    var pageTracker = _gat._getTracker("UA-2437988-20");
    pageTracker._trackPageview();
    } catch(err) {}
</script>
|,
    :GCX_login_info => %|
<p>What is GCX login?</p>
<p>GCX is a single sign on login that authenticates you to use Campus for Christ web applications including:</p>
<p>
<ul><li><a href="http://pulse.campusforchrist.org">Pulse</a></li>
  <li><a href="http://pat.powertochange.org">Project Application Tool</a></li>
  <li><a href="http://intranet.campusforchrist.org">Registration/Intranet</a></li>
  <li><a href="http://resources.powertochange.org">Resources</a></li>
  <li><a href="http://mpdtool.powertochange.org">MPD Tool</a></li>
</ul>
</p>
<p>Your GCX username will authenticate you to all these sites using one login.  You do not have to create a new one each time!  Contact us at helpdesk@c4c.ca if you have any questions about your GCX username.  Thank you!
<br>
</p>
    |,
    :add_person_default_staff_role => 'Staff',
    :date => {
      :formats => {
        :default => "%m/%d/%Y",
        :short => "%e %b",
        :long => "%B %e, %Y",
        :only_day => "%e",
        :long_ordinal => lambda { |date| "%B #{date.day.ordinalize}, %Y" },
        :short_ordinal => lambda { |date| "%B #{date.day.ordinalize}" }
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
          :default => "%Y-%m-%d %H:%M:%S %Z",
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
          :record_invalid => "Validation failed: {{errors}}"
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
      
  
