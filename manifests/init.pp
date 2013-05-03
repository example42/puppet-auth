class auth (
  $mode,
  $ldap_servers       = '',
  $ldap_basedn        = '',
  $ldap_ssl           = '',
  $ldap_cacert_path   = '',
  $ldap_cacert_source = '',
  $ldap_servers       = ''
  ) {

  $bool_ldap_ssl = any2bool($ldap_ssl)
  $ldap_nslcd_uid = 'nslcd'
  $ldap_nslcd_gid = $::operatingsystem ? {
    /(redhat|centos)/ => 'ldap',
    default           => 'nslcd',
  }
  $real_ldap_cacert_path = $ldap_cacert_path ? {
    ''      => $::operatingsystem ? {
      /(?i:redhat|centos)/  => '/etc/openldap/cacert.pem',
      /(?i:debian|ubuntu)/  => '/etc/ldap/cacert.pem',
    },
    default => $ldap_cacert_path,
  }
  include "auth::${mode}"

}
