#
# = Type: drupal::nginx::site
#
# Configure database and web server to host a Drupal web-site.
#
# == Parameters:
#
# $ensure::   Configure site? Default: present.
# $path::     Path to web root.
# $hostname:: Canonical hostname for the site.
# $aliases::  Other server names.
# $dbname::   Database name.
# $dbuser::   Database username.
# $dbpass::   Database password.
# $dbhost::   Database password. Default: localhost
# $pool::     PHP FPM pool to use. Default: www
# $redirect_hosts:: List of Nginx hostnames to redirect.
# $sslkey::   SSL key file. Optional.
# $sslcrt::   SSL certificate file. Optional.
#
# == Sample Usage:
#
#   drupal::nginx::site { 'robocop' :
#     ensure => present,
#     path => '/var/www/robocop/',
#     hostname  => 'robocop.ocp.com',
#     dbhost => 'db1.ocp.com',
#     dbname => 'robocop_site',
#     dbuser => 'robocop',
#     dbpass => 'robopass',
#     pool => 'ocp',
#     redirect_hosts => '*.robocop.ocp.com *.robocop.com police.detroitmi.gov',
#   }
#
define drupal::nginx::site (
    $ensure = 'present',
    $path,
    $hostname,
    $aliases = [],
    $pool = 'www',
    $redirect_hosts = '',
    $sslkey = undef,
    $sslcrt = undef,
    $passwdfile = ''
) {

  include drupal::nginx

  Drupal::Site["$title"] ~> Class['nginx::service']

  # XXX TODO: These paths should be set in drupal::params
  $site_config = "/etc/nginx/sites-available"
  $nginx_fastcgi_config = "/etc/nginx/includes/fastcgi_params.conf"
  $nginx_site_config = "/etc/nginx/includes/drupal_site_config.conf"

  case $ensure {
    'present' : {
      # Require File[$path]
      # Require Php::Fpm::Pool[$pool]
    }
  }

  # Build the site configuration file.
  $uri = "http://$hostname/"
  $listen = "80"

  # Create the configuration file for the site.
  file { "drupal-site-$title" :
    ensure => present,
    path => "$site_config/drupal-$title",
    content => template('drupal/nginx-site.erb'),
    require => [Class['drupal::configuration']],
  }

  # Link the configuration file into place.
  file { "/etc/nginx/sites-enabled/drupal-$title" :
    ensure => $ensure ? {
      enabled => 'link',
      present => 'link',
      default => 'absent',
    },
    target => "/etc/nginx/sites-available/drupal-$title",
    require => File["drupal-site-$title"],
  }

  # nginx configuration for version info
  nginx::site { 'mitx-release':
    ensure => 'enabled',
    source => 'puppet:///modules/lms/nginx/mitx-release',
  }

  # Configure a cron job for the resource.
  drupal::cron { $title :
    path => $path,
    uri => $uri,
  }
}

