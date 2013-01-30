#
# = Class: drupal::params
#
# Parameters to be applied module-wide.
#
# == TODO
#
# Update this module to allow users to override the specified values.
#
class drupal::params {

  # PATH to use when running drush core-cron in a cron job
  $cron_path = "/usr/sbin:/usr/bin:/sbin:/bin"

  # Enable --yes for drush core-cron
  $cron_yes = yes
  
  # Enable --quiet for drush cron-core
  $cron_quiet = yes

  # Run drush cron-core as this user
	$cron_user = $operatingsystem ? {
		ubuntu => 'www',
		debian => 'www',
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
