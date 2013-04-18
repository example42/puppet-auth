class auth::ldap ( ) {

  # Cross OS management of ldap authentication (with SSL) is
  # a true PITA to manage in a uniformed way
  # Risking some code duplication we prefer to use a simple per-OS
  # approach: for each supported version a specific class is included

  case $::operatingsystem {

    Debian: {
      case $::lsbmajdistrelease {
        5: { include auth::ldap::debian5 }
        6: { include auth::ldap::debian6 }
        default { fail("Unsupported platform: ${::operatingsystem} - ${::lsbmajdistrelease} ") }
      }
    }     
    Ubuntu: {
      case $::lsbmajdistrelease {
        8.04: { include auth::ldap::ubuntu0804 }
        10.04: { include auth::ldap::ubuntu1004 }
        12.04: { include auth::ldap::ubuntu1204 }
        default { fail("Unsupported platform: ${::operatingsystem} - ${::lsbmajdistrelease} ") }
      }
    }
    RedHat,Centos: {
      case $::lsbmajdistrelease {
        5: { include auth::ldap::redhat5 }
        6: { include auth::ldap::redhat6 }
        default { fail("Unsupported platform: ${::operatingsystem} - ${::lsbmajdistrelease} ") }
      }
    }

    default { fail("Unsupported platform: ${::operatingsystem} - ${::lsbmajdistrelease} ") }

}
