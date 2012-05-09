#
# = Class: drupal
#
# Install and configure services to host Drupal sites.
#
# == Requires:
#
# thsutton-nginx
# thsutton-mysql
# thsutton-php
#
# == Sample Usage:
#
#   include drupal
#
class drupal {

  include nginx
  include php::sapi::fpm
  include mysql::server

  php::extension { 'apc' : ensure => enabled }
  php::extension { 'gd' : ensure => enabled }
  php::extension { 'mysql' : ensure => enabled }
  php::extension { 'curl' : ensure => enabled }

  # php::fpm::pool { 'www' : ensure => absent }
  # php::fpm::pool { 'drupal': ensure => present }

  include drupal::drush
  include drupal::configuration

}
