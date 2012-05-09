#
# Class: drupal::params
#
# Parameters to be applied module-wide.
#
class drupal::params {

	$cron_user = $operatingsystem ? {
		ubuntu => 'www-data',
		debian => 'www-data',
		default => 'nobody',
	}

	$cron_yes = 'no'

	$drush_packages = $operatingsystem ? {
		ubuntu => 'drush',
		debian => 'drush',
		default => 'drush',
	}

}
