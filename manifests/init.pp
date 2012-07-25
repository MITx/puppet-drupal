#
# = Class: drupal
#
# Prepare a server to host Drupal web-sites.
#
#
# == Sample Usage:
#
#   include drupal
#   include drupal::nginx
#   drupal::nginx::site { 'example.com' :
#     ensure => present,
#     path => '/var/www/example.com/htdocs',
#     hostname => 'example.com',
#     redirect_hosts => '*.example.com example.co.uk *.example.co.uk'
#   }
#
class drupal {
  include mysql::server

  php::extension { 'apc' : ensure => enabled }
  php::extension { 'curl' : ensure => enabled }
  php::extension { 'gd' : ensure => enabled }
  php::extension { 'mcrypt' : ensure => enabled }
  php::extension { 'mysql' : ensure => enabled }

  augeas { "configure-apc-cache" :
    context => "/files/etc/php5/conf.d/apc.ini",
    changes => ["set apc/apc.enabled 1", "set apc/apc.shm_size 128M"],
    # notify => Class['php::sapi::fpm::service'],
  }

  include drupal::drush

}
