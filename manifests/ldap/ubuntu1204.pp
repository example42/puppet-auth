# = Class auth::ldap::ubuntu1204
#
# This class manages the configurations to setup LDAP
# authentication for ubuntu1204
#
class auth::ldap::ubuntu1204 {

  include auth::ldap::common

  if ! defined(Package['ldap-utils']) { package { 'ldap-utils': ensure => present } }
  if ! defined(Package['libpam-ldapd']) { package { 'libpam-ldapd': ensure => present } }
  if ! defined(Package['libnss-ldapd']) { package { 'libnss-ldapd': ensure => present } }

  # TODO: NSCD CONFIGURATION SHOULD BE MOVED TO A DEDICATED MODULE
  if ! defined(Package['nscd']) { package { 'nscd': ensure => present } }
  service { 'nscd':
    name       => 'nscd',
    ensure     => running,
    enable     => true,
    hasrestart => true,
    subscribe  => [ File['ldap.conf'],File['nscd.conf'],File['nsswitch.conf'] ],
  }

  # TODO: NSLCD CONFIGURATION SHOULD BE MOVED TO A DEDICATED MODULE
  # required as workaround for Debian bug #579647 also affecting Ubuntu
  file { 'nslcd.conf':
    ensure  => present,
    path    => '/etc/nslcd.conf',
    mode    => '0644',
    owner   => 'root',
    group   => 'root',
    before  => [ Package['libpam-ldapd'],Package['libnss-ldapd'] ],
    content => template('auth/ldap/nslcd.conf.erb'),
  }
  service { 'nslcd':
    name       => 'nslcd',
    ensure     => running,
    enable     => true,
    hasrestart => true,
    subscribe  => [ File['nslcd.conf'] ],
  }

  # PAM MANAGEMENT
  pam::config { 'common-account':
    source => 'puppet:///modules/auth/ldap/pam/common-account-ubuntu1204',
  }

  pam::config { 'common-auth':
    source => 'puppet:///modules/auth/ldap/pam/common-auth-ubuntu1204',
  }

  pam::config { 'common-password':
    source => 'puppet:///modules/auth/ldap/pam/common-password-ubuntu1204',
  }

  pam::config { 'common-session':
    source => 'puppet:///modules/auth/ldap/pam/common-session-ubuntu1204',
  }

  pam::config { 'su':
    source => 'puppet:///modules/auth/ldap/pam/su-ubuntu1204',
  }

}
