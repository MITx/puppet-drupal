#
# = Type: drupal::site
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
# $sslkey::   SSL key file. Optional.
# $sslcrt::   SSL certificate file. Optional.
#
# == Sample Usage:
#
#   drupal::site { 'robocop' :
#     ensure => present,
#     path => '/var/www/robocop/',
#     hostname  => 'robocop.ocp.com',
#     dbhost => 'db1.ocp.com',
#     dbname => 'robocop_site',
#     dbuser => 'robocop',
#     dbpass => 'robopass',
#     pool => 'ocp',
#   }
#
define drupal::site (
    $ensure = 'present'
  , $path
  , $hostname
  , $dbname
  , $dbuser
  , $dbpass
  , $dbhost = 'localhost'
  , $pool = 'www'
  , $ssl = undef
) {

  # XXX TODO: These paths should be set in drupal::params
  $site_conf = "/etc/nginx/sites-available"
  $nginx_fastcgi_config = "/etc/nginx/includes/fastcgi_params.conf"
  $nginx_site_config = "/etc/nginx/includes/drupal_site_config.conf"


  case $ensure {
    'present' : {
      # Require File[$path]
      # Require Php::Fpm::Pool[$pool]
    }
  }

  # MySQL configuration
  mysql_user { "$dbuser@$dbhost" :
    ensure => $ensure,
    password => mysql_hash($dbpass)
  }
  mysql_database { "$dbhost/$dbname" :
    ensure => $ensure,
  }
  mysql_grant { "$dbuser@$dbhost/$dbname" :
    ensure => $ensure,
    privileges => all
  }


  # Build the site configuration file.
  file { "drupal-site-$title" :
    ensure => present,
    path => "$site_config/drupal-$title",
    content => template('drupal/nginx-site.conf'),
    require => [Class['drupal::configuration']],
  }

  file { "/etc/nginx/sites-enabled/drupal-$title" :
    ensure => $ensure ? {
      enabled, present => 'link',
      default => 'absent',
    },
    target => "/etc/nginx/sites-available/drupal-$title",
    require => File["drupal-site-$title"],
    notify => Class['nginx::service'],
  }

  drupal::cron { $title :
    path => $path,
    uri => $uri,
  }

  Class['drupal::configuration'] -> Defined::Type["$title"]
}

