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
  file { '/etc/nginx/drupal-site.conf' :
    ensure => present,
    content = template('drupal/nginx-drupal.erb'),
  }
}
