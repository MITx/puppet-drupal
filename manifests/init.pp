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
  include php::fpm
  include mysql::server

  # php::extension { 'apc' : ensure => present }
  # php::extension { 'gd' : ensure => present }
  # php::extension { 'mysql' : ensure => present }

  # php::fpm::pool { 'www' : ensure => absent }
  # php::fpm::pool { 'drupal': ensure => present }

  include drupal::configuration
}
