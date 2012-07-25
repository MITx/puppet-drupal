# = Class: drupal::nginx::configuration
#
# This class creates the Drupal-specific configuration files for use
# by Nginx vhosts, etc.
#
# == Requires
#
# Nothing
#
# == Sample Usage:
#
#   class { 'drupal::nginx::configuration' :
#     include_support => ['ad'],
#   }
#
class drupal::nginx::configuration ( 
    $include_support = $drupal::params::nginx_support_modules
  , $nginx_includes = $drupal::params::nginx_includes
  , $nginx_fastcgi_config = $drupal::params::nginx_fastcgi_config
  , $nginx_site_config = $drupal::params::nginx_site_config
  , $nginx_server_config = '/etc/nginx/conf.d/drupal.conf'
) inherits drupal::params {

  file { $nginx_includes :
    ensure => directory,
    owner => "root",
    group => "root",
    mode => "0755",
  }
  
  file { $nginx_site_config :
    ensure => present,
    content => template('drupal/nginx-drupal.erb'),
  }

  file { $nginx_fastcgi_config :
    ensure => present,
    content => template('drupal/nginx-fastcgi.erb'),
  }

  file { $nginx_server_config :
    ensure => present,
    owner => 'root',
    group => 'root',
    mode => '0644',
    content => template('drupal/nginx-server.erb'),
  }
  
}

Package['nginx'] -> Class['drupal::configuration']
