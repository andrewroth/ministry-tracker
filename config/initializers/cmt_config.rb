module Cmt
  CONFIG = {
    # Allow GCX logins in the form on the CMT login page.
    :gcx_direct_logins => false,

    # Allow local user logins in the form on the CMT login page.
    :local_direct_logins => false,

    # Allow GCX logins using the GCX login page (aka the greenscreen).
    # This will show a link on the login page.  If the direct GCX or
    # local logins are also allowed, both the form and link will be
    # displayed.
    :gcx_greenscreen => true,
    
    # Disable GCX Import functionality
    :gcx_import_disabled => true,

    # Allow local logins.  Either this of gcx_account_enabled must be true.
    :local_enabled => true,

    # Forces users to go through a longer process for validating accounts.
    # Note used yet.
    :full_account_verification => true,
    
    # Removes the options of specifying 'poor' timeslots in timetable
    :hide_poor_status_in_scheduler => true,
    
    # Default ministry name
    :default_ministry_name => 'Campus for Christ',
    
    #Associate person with no ministry to default ministry
    :associate_with_default_ministry => true,
    
    # Default Country - When set, the campus filter is disabled and all 
    # campuses from this country are displayed
    # Set to nil(:campus_scope_country => nil) to disable.
    :campus_scope_country => 'Canada',
    
    :default_country => 'Canada',

    # Disable second address line
    :disable_address2 => true,
    
    # Default website title appearing at the top of the browser
    :web_title => 'Campus for Christ :: Movement Tracker',

    # When no Permission object is found for a controller/action,
    # does the user have permission
    :permissions_granted_by_default => false,
    
    # When true, hides timetable impact dropdown in group_types form
    :disable_group_timetable_impact => true,
    
    # When enabled, users will be able to use the 'find common times' algorithim when making groups
    :find_common_times_enabled => false,
    
    # All staff can edit any student's timetable in their ministry
    :staff_can_edit_student_timetables => false
  }
end

