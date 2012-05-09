#
# Class: drupal::params
#
# Parameters to be applied module-wide.
#
class drupal::params {

	$cron_default = 'enable'

	$cron_user = $operatingsystem ? {
		ubuntu => 'www-data',
		debian => 'www-data',
		default => 'nobody',
	}


	$drush_packages = $operatingsystem ? {
		ubuntu => 'drush',
		debian => 'drush',
		default => 'drush',
	}

	$nginx_includes = "/etc/nginx/includes"
	$nginx_fastcgi_config = "$nginx_includes/fastcgi_params.conf"
	$nginx_site_config = "$nginx_includes/drupal_site_config.conf"

	$nginx_support_modules = []

}
