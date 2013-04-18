# = Class auth::ldap::debian5
#
# This class manages the configurations to setup LDAP
# authentication for debian5
#
class auth::ldap::debian5 {

  include auth::ldap::common

  if ! defined(Package['ldap-utils']) { package { 'ldap-utils': ensure => present } }
  if ! defined(Package['libpam-ldap']) { package { 'libpam-ldap': ensure => present } }
  if ! defined(Package['libnss-ldap']) { package { 'libnss-ldap': ensure => present } }

  # TODO: NSCD CONFIGURATION SHOULD BE MOVED TO A DEDICATED MODULE
  if ! defined(Package['nscd']) { package { 'nscd': ensure => present } }
  service { 'nscd':
    name       => 'nscd',
    ensure     => running,
    enable     => true,
    hasrestart => true,
    subscribe  => [ File['ldap.conf'],File['nscd.conf'],File['nsswitch.conf'] ],
  }
  file { '/etc/nss-ldapd.conf':
    ensure => absent ,
    notify => Service['nscd'],
  }

  # Debian , by default, uses a separated file for pam ldap settings
  file { 'pam_ldap.conf':
    ensure  => present,
    path    => '/etc/pam_ldap.conf',
    mode    => '0644',
    owner   => 'root',
    group   => 'root',
    content => template('auth/ldap/ldap.conf.erb'),
    before  => File['nsswitch.conf'],
  }

  # PAM MANAGEMENT
  pam::config { 'common-account':
    source => 'puppet:///modules/auth/ldap/pam/common-account-debian5',
  }

  pam::config { 'common-auth':
    source => 'puppet:///modules/auth/ldap/pam/common-auth-debian5',
  }

  pam::config { 'common-password':
    source => 'puppet:///modules/auth/ldap/pam/common-password-debian5',
  }

  pam::config { 'common-session':
    source => 'puppet:///modules/auth/ldap/pam/common-session-debian5',
  }

  pam::config { 'su':
    source => 'puppet:///modules/auth/ldap/pam/su-debian5',
  }

}
