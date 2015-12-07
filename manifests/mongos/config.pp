# PRIVATE CLASS: do not call directly
class mongodb::mongos::config (
  $ensure         = $mongodb::mongos::ensure,
  $user           = $mongodb::mongos::user,
  $group          = $mongodb::mongos::group,
  $config         = $mongodb::mongos::config,
  $config_content = $mongodb::mongos::config_content,
  $configdb       = $mongodb::mongos::configdb,
  $keyfile        = $mongodb::mongos::keyfile,
  $key            = $mongodb::mongos::key,
  $dbpath         = undef,
) {

  if ($ensure == 'present' or $ensure == true) {

    #Pick which config content to use
    if $config_content {
      $config_content_real = $config_content
    } else {
      $config_content_real = template('mongodb/mongodb.conf.2.6.erb')
    }

    file { $config:
      content => $config_content_real,
      owner   => 'root',
      group   => 'root',
      mode    => '0644',
    }

    if $keyfile and $key {
      validate_string($key)
      validate_re($key,'.{6}')
      file { $keyfile:
        content => $key,
        owner   => $user,
        group   => $group,
        mode    => '0400',
      }
    }
  }
}
