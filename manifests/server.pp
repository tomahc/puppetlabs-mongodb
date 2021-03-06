# This installs a MongoDB server. See README.md for more details.
class mongodb::server (
  $ensure           = $mongodb::params::ensure,

  $user             = $mongodb::params::user,
  $group            = $mongodb::params::group,

  $config           = $mongodb::params::config,
  $dbpath           = $mongodb::params::dbpath,
  $pidfilepath      = $mongodb::params::pidfilepath,

  $service_manage   = $mongodb::params::service_manage,
  $service_provider = $mongodb::params::service_provider,
  $service_name     = $mongodb::params::service_name,
  $service_enable   = $mongodb::params::service_enable,
  $service_ensure   = $mongodb::params::service_ensure,
  $service_status   = $mongodb::params::service_status,

  $package_ensure  = $mongodb::params::package_ensure,
  $package_name    = $mongodb::params::server_package_name,

  $logpath         = $mongodb::params::logpath,
  $logrotate       = $mongodb::params::logrotate,
  $bind_ip         = $mongodb::params::bind_ip,
  $ipv6            = undef,
  $logappend       = true,
  $fork            = $mongodb::params::fork,
  $port            = undef,
  $journal         = $mongodb::params::journal,
  $nojournal       = undef,
  $smallfiles      = undef,
  $cpu             = undef,
  $auth            = false,
  $noauth          = undef,
  $verbose         = undef,
  $verbositylevel  = undef,
  $objcheck        = undef,
  $quota           = undef,
  $quotafiles      = undef,
  $diaglog         = undef,
  $directoryperdb  = undef,
  $profile         = undef,
  $maxconns        = undef,
  $oplog_size      = undef,
  $nohints         = undef,
  $nohttpinterface = undef,
  $noscripting     = undef,
  $notablescan     = undef,
  $noprealloc      = undef,
  $nssize          = undef,
  $mms_token       = undef,
  $mms_name        = undef,
  $mms_interval    = undef,
  $replset         = undef,
  $configsvr       = undef,
  $shardsvr        = undef,
  $rest            = undef,
  $quiet           = undef,
  $slowms          = undef,
  $keyfile         = undef,
  $key             = undef,
  $set_parameter   = undef,
  $syslog          = undef,
  $config_content  = undef,
  $ssl             = undef,
  $ssl_key         = undef,
  $ssl_ca          = undef,
  $restart         = $mongodb::params::restart,
  $storage_engine  = undef,

  # Deprecated parameters
  $master          = undef,
  $slave           = undef,
  $only            = undef,
  $source          = undef,
) inherits mongodb::params {


  if $ssl {
    validate_string($ssl_key, $ssl_ca)
  }

  if ($ensure == 'present' or $ensure == true) {
    if $restart {
      anchor { 'mongodb::server::start': }->
      class { 'mongodb::server::install': }->
      # If $restart is true, notify the service on config changes (~>)
      class { 'mongodb::server::config': }~>
      class { 'mongodb::server::service': }->
      anchor { 'mongodb::server::end': }
    } else {
      anchor { 'mongodb::server::start': }->
      class { 'mongodb::server::install': }->
      # If $restart is false, config changes won't restart the service (->)
      class { 'mongodb::server::config': }->
      class { 'mongodb::server::service': }->
      anchor { 'mongodb::server::end': }
    }
  } else {
    anchor { 'mongodb::server::start': }->
    class { '::mongodb::server::service': }->
    class { '::mongodb::server::config': }->
    class { '::mongodb::server::install': }->
    anchor { 'mongodb::server::end': }
  }
}
