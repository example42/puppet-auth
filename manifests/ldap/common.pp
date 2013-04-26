# = Class auth::ldap::common
#
# This class contains the general settings for ldap authentication
#
class auth::ldap::common {

  # LDAP CONFIG FILE FOR NSS
  $ldap_conf_path = $::operatingsystem ? {
    debian  => '/etc/libnss-ldap.conf',
    default => '/etc/ldap.conf',
  }
  file { 'ldap.conf':
    ensure  => present,
    path    => $ldap_conf_path,
    mode    => '0644',
    owner   => 'root',
    group   => 'root',
    content => template('auth/ldap/ldap.conf.erb'),
    before  => File['nsswitch.conf'],
  }

  # NSS CONFIG FILE
  $nsswitch_conf_template = $::operatingsystem ? {
    /(?i:redhat|centos)/ => $::lsbmajdistrelease ? {
      6       => 'auth/ldap/nsswitch.conf.redhat6.erb',
      default => 'auth/ldap/nsswitch.conf.erb',
    },
    default           => 'auth/ldap/nsswitch.conf.erb',
  }
  file { 'nsswitch.conf':
    ensure  => present,
    path    => '/etc/nsswitch.conf',
    mode    => '0644',
    owner   => 'root',
    group   => 'root',
    content => template($nsswitch_conf_template),
  }

  # NSCD CONFIG FILE AND HARD PATCH
  $nscd_conf_ensure = $::operatingsystem ? {
    /(?i:redhat|centos)/ => $::lsbmajdistrelease ? {
      6       => absent,
      default => present,
    },
    default           => present,
  }
  file { 'nscd.conf':
    ensure  => $nscd_conf_ensure,
    path    => '/etc/nscd.conf',
    mode    => '0644',
    owner   => 'root',
    group   => 'root',
    content => template('auth/ldap/nscd.conf.erb'),
  }
  file { 'nscd_bug_watcher':
    ensure  => $nscd_conf_ensure,
    path    => '/etc/cron.d/nscd-bug-watcher',
    mode    => '0644',
    owner   => 'root',
    group   => 'root',
    content => template('auth/ldap/nscd-bug-watcher.erb'),
  }

  # OPENLDAP CLIENT CONFIG FILE
  $openldap_ldap_conf_path = $::operatingsystem ? {
    /(?i:redhat|centos)/  => '/etc/openldap/ldap.conf',
    /(?i:debian|ubuntu)/  => '/etc/ldap/ldap.conf',
  }
  file { 'openldap_ldap.conf':
    ensure  => present,
    path    => $openldap_ldap_conf_path,
    mode    => '0644',
    owner   => 'root',
    group   => 'root',
    content => template('auth/ldap/openldap-ldap.conf.erb'),
  }

  # CACERT FILE, IF PROVIDED
  $openldap_cacert_path = $::operatingsystem ? {
    /(?i:redhat|centos)/  => '/etc/openldap/cacert.pem',
    /(?i:debian|ubuntu)/  => '/etc/ldap/cacert.pem',
  }
  if $auth::ldap_cacert_source != '' {
    file { 'ldap_cacert':
      ensure  => present,
      path    => $openldap_cacert_path,
      mode    => '0644',
      owner   => 'root',
      group   => 'root',
      source  => $auth::ldap_cacert_source,
    }
  }

}
