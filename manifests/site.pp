
# == Sample Usage:
#
#   drupal::site { 'robocop' :
#     ensure => present,
#     path => '/var/www/robocop/',
#     dbhost => 'db1.ocp.com',
#     dbname => 'robocop_site',
#     dbuser => 'robocop',
#     dbpass => 'robopass',
#     pool => 'ocp',
#   }
#
define drupal::site (
  $ensure => present
  , $path
  , $dbname
  , $dbuser
  , $dbpass
  , $dbhost = 'localhost'
  , $pool = 'www'
  , $ssl = undef
) {

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

  file { "/etc/nginx/sites-available/drupal-$title" :
    ensure => $ensure,
    content => template('drupal/nginx-site.erb'),
  }

  file { "/etc/nginx/sites-enabled/drupal-$title" :
    ensure => $ensure ? {
      enabled, present => 'link',
      default => 'absent',
    },
    target => "/etc/nginx/sites-available/drupal-$title",
    require => File["/etc/nginx/sites-available/drupal-$title"],
    notify => Class['nginx::service'],
  }

  Class['drupal::configuration'] -> Defined::Type["$title"]
}

