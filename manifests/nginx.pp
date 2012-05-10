#
# = Class: drupal::nginx
#
# Install and configure services to host Drupal sites.
#
# == Requires:
#
# puppetlabs-mysql
# thsutton-nginx
# thsutton-php
#
# == Sample Usage:
#
#   include drupal::nginx
#
class drupal::nginx {

  include nginx
  include php::sapi::fpm
  include mysql::server

  php::extension { 'apc' : ensure => enabled }
  php::extension { 'curl' : ensure => enabled }
  php::extension { 'gd' : ensure => enabled }
  php::extension { 'mcrypt' : ensure => enabled }
  php::extension { 'mysql' : ensure => enabled }

  augeas { "configure-apc-cache" :
    context => "/files/etc/php5/conf.d/apc.ini",
    changes => ["set apc/apc.enabled 1", "set apc/apc.shm_size 128M"],
    notify => Class['php::sapi::fpm::service'],
  }

  # php::fpm::pool { 'www' : ensure => absent }
  # php::fpm::pool { 'drupal': ensure => present }

  include drupal::drush
  include drupal::configuration
}
