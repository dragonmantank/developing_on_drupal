class php(
  $php_packages = ['php5', 'php5-mysql', 'php5-gd', 'php5-xdebug', 'php5-mcrypt', 'php5-cli', 'php5-dev','php5-curl', 'php-pear'],
  $usePHP55 = false
) {
  file { "/etc/apt/sources.list.d/dotdeb.list":
    ensure => file,
    owner => root,
    group => root,
    content => template('php/dotdeb.list.erb'),
  }

  exec { "import-gpg":
    command => "/usr/bin/wget -q http://www.dotdeb.org/dotdeb.gpg -O -| /usr/bin/apt-key add -",
    before => Exec['apt-get update'],
    require => File['/etc/apt/sources.list.d/dotdeb.list']
  }

  package { $php_packages:
    ensure => 'present',
    notify => Service['apache2'],
    require => Exec['apt-get update']
  }

  file {'/etc/php5/apache2/conf.d/timezone.ini':
    owner  => root,
    group  => root,
    mode   => 664,
    content => template('php/timezone.ini.erb'),
    require => Package['php5'],
    notify => Service['apache2'],
  }

  exec {"enable-php5":
    creates => '/etc/apache2/mods-enabled/php5.conf',
    command => "a2enmod php5",
    require => Package['php5'],
    path => ['/usr/bin', '/bin', '/usr/sbin'],
    notify => Service['apache2'],
    timeout => 0,
  }

  exec {"install-composer":
    command => "curl -sS http://getcomposer.org/installer | php -- --install-dir=/bin --filename=composer",
    require => [Package['curl', 'php5-cli']]
  }
}