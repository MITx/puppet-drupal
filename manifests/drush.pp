#
# = Class: drupal::drush
#
# Install the Drush command line interface for Drupal.
#
class drupal::drush (
	$packages = $drupal::params::drush_packages
) inherits drupal::params {

  package { $packages :
    ensure => installed,
  }

}
