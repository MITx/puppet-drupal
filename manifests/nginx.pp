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
  include php::sapi::fpm
  include '::nginx'

  nginx::htpasswd::add { 'drupal':
    user => 'edx',
    hash => '$apr1$5IoXSBZr$avDUSZ4RhhZ5A0MR9eqS0.',
  }

  # Install Drush and our configuration
  include drupal
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
