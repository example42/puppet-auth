# = Class auth::ldap::redhat5
#
# This class manages the configurations to setup LDAP
# authentication for redhat5
#
class auth::ldap::redhat5 {

  include auth::ldap::common

  if ! defined(Package['openldap-clients']) { package { 'openldap-clients': ensure => present } }
  if ! defined(Package['nss_ldap']) { package { 'nss_ldap': ensure => present } }

  # TODO: NSCD CONFIGURATION SHOULD BE MOVED TO A DEDICATED MODULE
  if ! defined(Package['nscd']) { package { 'nscd': ensure => present } }
  service { 'nscd':
    name       => 'nscd',
    ensure     => running,
    enable     => true,
    hasrestart => true,
    subscribe  => [ File['ldap.conf'],File['nscd.conf'],File['nsswitch.conf'] ],
  }

  # PAM MANAGEMENT
  pam::config { 'system-auth-ac':
    source => 'puppet:///modules/auth/ldap/pam/system-auth-ac-redhat5',
  }

}
