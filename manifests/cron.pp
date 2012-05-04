#
# = Class: drupal::cron
#
# Configure a cron job to process cron tasks for a Drupal site. Invokes drush
# to handle the processing.
#
# == Parameters:
#
# $path::    Path to the Drupal site.
# $uri::     URI for the Drupal site.
# $user::    User to own cron job.
# $hours::   Cron hours specification.
# $minutes:: Cron minutes specification.
# $quiet::   Be quiet?
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
    $path
  , $uri = undef
  , $user = "www-data"
  , $hours = "*"
  , $minutes = "*/5"
  , $quiet = true
) {

  $real_path = "--root=$path"
  $real_uri = $uri ? {
    undef   => "",
    default => "--uri=$uri",
  }
  $real_quite = $quiet ? {
    false   => "",
    default => "--quiet",
  }
  $command = " drush $real_path $real_uri $real_quiet core-cron"
  $run_command = "/usr/bin/env PATH=/usr/sbin:/usr/bin:/sbin:/bin COLUMNS=72"

  cron { "drupal-cron-$title" :
    command => "$run_command $command",
    user    => $user,
    hour    => $hours,
    minute  => $minutes,
    require => Class['drupal::drush'],
  }

}
