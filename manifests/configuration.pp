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
class drupal::configuration ( $include_support = [] ) {

  # XXX TODO: Set this file up.
  $nginx_fastcgi_config = "/etc/nginx/includes/fastcgi_params.conf"
  # XXX TODO: Create this file.
  $nginx_site_config = "/etc/nginx/includes/drupal_site_config.conf"
  
  file { $nginx_site_config :
    ensure => present,
    content = template('drupal/nginx-drupal.erb'),
  }

  file { $nginx_fastcgi_config :
    ensure => present,
    content => template('drupal/nginx-fastcgi.erb'),
  }
  
}
