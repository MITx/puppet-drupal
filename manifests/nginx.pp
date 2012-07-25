#
# = Class: drupal::nginx
#
# Install and configure services to host Drupal sites using Nginx and PHP-FPM.
#
# == Requires:
#
# puppetlabs-mysql
# thsutton-nginx
# thsutton-php
#
# == Sample Usage:
#
#   include drupal::nginx
#
class drupal::nginx {

  # Ensure Nginx and PHP-FPM are installed.
  include nginx
  include php::sapi::fpm

  # Install Drush and our configuration
  include drupal::drush  
  include drupal::nginx::configuration

  # Update the PHP memory limit.
  # XXX TODO: This config file should be a parameter
  augeas { "configure-php-limit" :
    context => "/files/etc/php5/fpm/php.ini",
    changes => ["set PHP/memory_limit 96M"],
    notify => Class['php::sapi::fpm::service'],
  }

}
