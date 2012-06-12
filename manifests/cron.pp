#
# = Class: drupal::cron
#
# Configure a cron job to process cron tasks for a Drupal site. Invokes drush
# to handle the processing.
#
# == Parameters:
#
# $path::    Path to the Drupal site.
# $root::    Alternate spelling of $path.
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
#      path => '/var/www/mysite/htdocs',
#    }
#  }
#
define drupal::cron (
    $path = undef
  , $root = undef
  , $ensure = "present"
  , $uri = undef
  , $user = "www-data"
  , $hours = "*"
  , $minutes = "*/5"
  , $quiet = true
) {

  # Check that the user supplied either $path or $root.
  if ($path == undef) and ($root == undef) {
    fail("Must specify either path or root to drupal::cron")
  }
  if ($path != undef) and ($root != undef) {
    fail("Must specify either path or root to drupal::cron")
  }

  # Figure out what path we should be using.
  $path_use = $path ? {
    undef   => $root,
    default => $path,
  }

  # Build the arguments to the command.
  $real_path = "--root=$path_use"
  $real_uri = $uri ? {
    undef   => "",
    default => "--uri=$uri",
  }
  $real_quiet = $quiet ? {
    false   => "",
    default => "--quiet",
  }

  # Build the command
  $command = "drush $real_path $real_uri $real_quiet core-cron"
  $run_command = "/usr/bin/env PATH=/usr/sbin:/usr/bin:/sbin:/bin COLUMNS=72"

  cron { "drupal-cron-$title" :
    ensure  => $ensure,
    command => "$run_command $command",
    user    => $user,
    hour    => $hours,
    minute  => $minutes,
    require => Class['drupal::drush'],
  }

}
