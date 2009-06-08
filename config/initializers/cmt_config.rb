module Cmt
  CONFIG = {
    # Allow GCX logins.
    # The signup process is slightly different if they want to use GCX.
    # They will be asked to log in with GCX in order to grab their 
    # GCX credentials and tie them to a user.
    :gcx_enabled => true,

    # Allow local logins.  Either this of gcx_account_enabled must be true.
    :local_enabled => true,

    # Forces users to go through a longer process for validating accounts.
    # Note used yet.
    :full_account_verification => true,
    
    # Removes the options of specifying 'poor' timeslots in timetable
    :hide_poor_status_in_scheduler => true,
    
    # Default ministry name
    :default_ministry_name => 'Campus for Christ',
    
    # Default Country - When set, the campus filter is disabled and all 
    # campuses from this country are displayed
    # Set to nil(:campus_scope_country => nil) to disable.
    :campus_scope_country => 'Canada',

    # Disable second address line
    :disable_address2 => false
  }
end

