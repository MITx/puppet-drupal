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
    $path,
    $hostname,
    $ensure = 'present',
    $aliases = [],
    $pool = 'www',
    $redirect_hosts = '',
    $sslkey = undef,
    $sslcrt = undef,
    $passwdfile = '',
) {

  $db_config = hiera_hash('drupal::db_config', {
      'database' => 'edx',
      'username' => 'root',
      'password' => 'root',
      'host'     => 'localhost',
      'port'     => '',
      'driver'   => 'mysql',
      'prefix'   => '',
  })

  include drupal::nginx
  include ::nginx

  # TODO Need to fix the service notifier
  # Drupal::Site["$title"] ~> Class['nginx::service']

  # XXX TODO: These paths should be set in drupal::params
  $site_config = '/etc/nginx/sites-available'
  $nginx_fastcgi_config = '/etc/nginx/includes/fastcgi_params.conf'
  $nginx_site_config = '/etc/nginx/includes/drupal_site_config.conf'

  # Build the site configuration file.
  $uri = "http://$hostname/"
  $listen = '80'

  # Create the configuration file for the site.
  file { "drupal-site-$title" :
    ensure  => present,
    path    => "$site_config/drupal-$title",
    content => template('drupal/nginx-site.erb'),
    # TODO this can probably be removed?
    # require => [Class['drupal::configuration']],
  }

  # settings.php is a template which has the db auth credentials

  file { '/opt/wwc/settings.php':
    ensure  => file,
    content => template('drupal/settings.php.erb'),
    mode    => '0600',
    owner   => 'www-data'
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
  ::nginx::site { 'mitx-release':
    ensure => 'enabled',
    source => 'puppet:///modules/lms/nginx/mitx-release',
  }

  # Configure a cron job for the resource.
  drupal::cron { $title :
    path => $path,
    uri => $uri,
  }
}

