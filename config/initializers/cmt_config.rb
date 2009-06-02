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
    # If 
    :full_account_verification => true,
  }
end

