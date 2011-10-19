#
# Class: drupal::drush
#
# Install the drush tool/s
#
class drupal::drush (
	$packages = $drupal::params::drush_packahes
) inherits drupal::params {

	package { $packages :
		ensure => installed,
	}

}
