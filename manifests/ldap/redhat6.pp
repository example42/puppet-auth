# = Class auth::ldap::redhat6
#
# This class manages the configurations to setup LDAP
# authentication for redhat6
#
class auth::ldap::redhat6 {

  include auth::ldap::common

  if ! defined(Package['openldap-clients']) { package { 'openldap-clients': ensure => present } }
  package { 'nss-pam-ldapd': ensure => absent }
  package { 'nscd': ensure => absent }

  # TODO: SSSD CONFIGURATION SHOULD BE MOVED TO A DEDICATED MODULE
  if ! defined(Package['sssd']) { package { 'sssd': ensure => present } }

  file { 'sssd.conf':
    ensure  => present,
    path    => '/etc/sssd/sssd.conf',
    mode    => '0600',
    owner   => 'root',
    group   => 'root',
    content => template('auth/ldap/sssd.conf.erb'),
  }

  service { 'sssd':
    name       => 'sssd',
    ensure     => running,
    enable     => true,
    hasrestart => true,
    subscribe  => File['sssd.conf'],
  }

}
