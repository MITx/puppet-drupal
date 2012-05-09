#
# = Class: drupal::drush
#
# Install the Drush command line interface for Drupal.
#
class drupal::drush {

  $package = $operatingsystem ? {
    ubuntu => 'drush',
    debian => 'drush',
  }

  package { $package :
    ensure => present,
  }

}
