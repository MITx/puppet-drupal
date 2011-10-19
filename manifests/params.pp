#
# Class: drupal::params
#
# Parameters to be applied module-wide.
#
class drupal::params {

	$drush_packages = $operatingsystem ? {
		unbuntu => 'drush',
		debian => 'drush',
		default => 'drush',
	}

}
