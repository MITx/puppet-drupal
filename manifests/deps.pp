class drupal::deps {
  package {['libaugeas-ruby1.9.1', 'augeas-tools',
      'nginx-full', 'libaugeas-dev', 'libaugeas-ruby']:
    ensure => present
  }
}
