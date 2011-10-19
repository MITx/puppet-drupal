#
# Class: drupal::drush
#
# Install the drush tool/s
#
class drupal::drush (
	$packages = $drupal::params::drush_packages
) inherits drupal::params {

	package { $packages :
		ensure => installed,
	}

}
