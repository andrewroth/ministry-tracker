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
    :help_link => "http://getsatisfaction.com/powertochange",
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
<p>What is TheKey login?</p>
<p>TheKey (formerly GCX) is a single sign-on login that authenticates you to use Power to Change web applications including:</p>
<p>
<ul><li><a href="http://pulse.campusforchrist.org">Pulse</a></li>
  <li><a href="http://pat.powertochange.org">Project Application Tool</a></li>
  <li><a href="http://intranet.campusforchrist.org">Registration/Intranet</a></li>
  <li><a href="http://resources.powertochange.org">Resources</a></li>
  <li><a href="http://mpdtool.powertochange.org">MPD Tool</a></li>
</ul>
</p>
<p>Your username will authenticate you to all these sites using one login via TheKey.  You do not have to create a new one each time!  Contact us at Helpdesk@powertochange.org if you have any questions about your username.  Thank you!
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
        :long_ordinal => lambda { |date| date.strftime("%B #{date.day.ordinalize}, %Y") },
        :short_ordinal => lambda { |date| date.strftime("%B #{date.day.ordinalize}") }
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
        :long_ordinal => lambda { |time| time.strftime("%B #{time.day.ordinalize}, %Y %H:%M") },
        :short_ordinal => lambda { |time| time.strftime("%B #{time.day.ordinalize}") }
      },
      :time_with_zone => {
        :formats => {
          :default => lambda { |time| time.strftime("%Y-%m-%d %H:%M:%S %Z") }
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
  }
}
