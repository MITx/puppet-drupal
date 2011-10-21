# Resource: drupal::cron
#
# Add a cron job for a Drupal site.
#
define drupal::cron (
	$ensure = "present",
	$root,
	$uri="",
	$user = $drupal::params::cron_user,
	$yes = $drupal::params::cron_yes
) {

	# Build the arguments to pass to the cron job
	$uri_arg = $uri ? {
		"" => "",
		default => "--uri='$uri'",
	}
	$root_arg = $root ? {
		"" => "",
		default => "--root='$root'",
	}
	$yes_arg = $yes ? {
		"yes" => "--yes",
		"true" => "--yes",
		"enable" => "--yes",
		default => "",
	}

	case $ensure {
		'present' : {
			cron { "drush-cron-$name" :
				ensure => present,
				command => "drush $uri_arg $root_arg $yes_arg cron 2>&1 > /dev/null",
				minute => "*/5", 
				user => $user,
				require => Class['drupal::drush'],
			}
		}

		'absent' : {
			cron { "drush-cron-$name" :
				ensure => absent,
				command => "drush $uri_arg $root_arg $yes_arg cron 2>&1 > /dev/null",
				minute => "*/5", 
				user => $user,
			}
		}
	}

}
