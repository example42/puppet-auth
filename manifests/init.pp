class auth (
  $auth,
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

  include "auth::${auth}"

}
