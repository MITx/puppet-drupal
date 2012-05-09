# = Class: drupal::configuration
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
#   class { 'drupal::configuration' :
#     include_support => ['ad'],
#   }
#
class drupal::configuration ( 
    $include_support = $drupal::params::nginx_support_modules
  , $nginx_includes = $drupal::params::nginx_includes
  , $nginx_fastcgi_config = $drupal::params::nginx_fastcgi_config
  , $nginx_site_config = $drupal::params::nginx_site_config
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
  
}

Package['nginx'] -> Class['drupal::configuration']
