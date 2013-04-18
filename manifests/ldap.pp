class auth::ldap ( ) {

  # Cross OS management of ldap authentication (with SSL) is
  # a true PITA to manage in an uniformed way
  # Risking some code duplication we prefer to use an hybrid approach:
  # - Common parts are in auth::ldap::common
  # - Per OS parts are in auth::ldap::<os>
  # - Per OS variables are generally defined where they are used or in auth

  case $::operatingsystem {
    Debian: {
      case $::lsbmajdistrelease {
        8.04:    { include auth::ldap::debian5 } # Hardy for old Facter versions
        5:       { include auth::ldap::debian5 }
#        6:       { include auth::ldap::ubuntu1204 } # TO VERIFY
        default: { fail("Unsupported platform: ${::operatingsystem} - ${::lsbmajdistrelease} ") }
      }
    }     
    Ubuntu: {
      case $::lsbmajdistrelease {
        8.04:    { include auth::ldap::debian5 }
        10.04:   { include auth::ldap::ubuntu1204 }
        12.04:   { include auth::ldap::ubuntu1204 }
        default: { fail("Unsupported/Untested platform: ${::operatingsystem} - ${::lsbmajdistrelease} ") }
      }
    }
    RedHat,Centos: {
      case $::lsbmajdistrelease {
        5:       { include auth::ldap::redhat5 }
        6:       { include auth::ldap::redhat6 }
        default: { fail("Unsupported platform: ${::operatingsystem} - ${::lsbmajdistrelease} ") }
      }
    }

    default: { fail("Unsupported platform: ${::operatingsystem} - ${::lsbmajdistrelease} ") }
  }
}
