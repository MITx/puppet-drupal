#
# = Class: drupal::cron
#
# Configure a cron job to process cron tasks for a Drupal site. Invokes drush
# to handle the processing.
#
# == Parameters:
#
# $root::    Path to the Drupal site.
# $uri::     URI for the Drupal site.
# $user::    User to own cron job.
# $hours::   Cron hours specification.
# $minutes:: Cron minutes specification.
# $quiet::   Be quiet?
#
# Users must specify either $path or $root, but not both.
# 
# == Requires:
#
# drupal::drush
#
# == Sample Usage:
#
#  class { 'mysite' :
#    drupal::cron { 'mysite' :
#      ensure => present,
#      path => '/var/www/mysite/htdocs',
#      uri => "http://mysite.org/",
#    }
#  }
#
define drupal::cron (
    $ensure = "present"
  , $root
  , $uri=""
  , $quiet = $drupal::params::cron_quiet
  , $yes = $drupal::params::cron_yes
  , $user = $drupal::params::cron_user
  , $hours = "*"
  , $minutes = "*/5"
  , $path = $drupal::params::cron_path
) {

  # We'll use drush in our cron job.
  include drupal::drush
  Class['drupal::drush'] -> Drupal::Cron["$title"]

  # Build the arguments to the command.
  $root_arg = "--root=$root"

  $uri_arg = $uri ? {
		"" => "",
		default => "--uri='$uri'",
	}

  $quiet_arg = $quiet ? {
    false   => "",
    no      => "",
    ""      => "",
    default => "--quiet",
  }

  $yes_arg = $yes ? {
		yes     => "--yes",
		true    => "--yes",
		enable  => "--yes",
		default => "",
	}
	
	# Build the command strings.
  $command = "drush $quiet_arg $yes_arg $root_arg $uri_arg core-cron"
  $run_command = "/usr/bin/env PATH=$path COLUMNS=72"

  # Create the cron resource.
  cron { "drupal-cron-$title" :
    ensure  => $ensure,
    command => "$run_command $command",
    user    => $user,
    hour    => $hours,
    minute  => $minutes,
  }

}
