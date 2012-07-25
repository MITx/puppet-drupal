#
# = Class: drupal::drush
#
# Install the Drush command line interface for Drupal.
#
# == Sample Usage:
#
#   include drupal::drush
#
class drupal::drush (
	$packages = $drupal::params::drush_packages
) inherits drupal::params {

	package { $packages :
		ensure => installed,
	}

}
