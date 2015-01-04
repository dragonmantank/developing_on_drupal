class apache2 (
    $doc_root = '/vagrant'
) {
    package {'apache2':
        ensure => 'present'
    }

    service {'apache2':
        ensure => 'running',
        require => Package['apache2'],
    }

    exec { "change_httpd_user":
      command => "sed -i 's/www-data/vagrant/g' /etc/apache2/envvars",
      onlyif => "/bin/grep -q 'www-data' '/etc/apache2/envvars'",
      notify => Service['apache2'],
      require => Package['apache2'],
    }
     
    file { "/var/lock/apache2":
      ensure => "directory",
      owner => "vagrant",
      group => "vagrant",
      require => Exec['change_httpd_user'],
    }

    file {'/etc/apache2/sites-enabled/vhost.conf':
        owner  => root,
        group  => root,
        mode   => 664,
        content => template('apache2/vhost.conf.erb'),
        notify => Service['apache2'],
        require => Package['apache2'],
    }

    file {'/etc/apache2/conf.d/enablesendfile.conf':
        owner  => root,
        group  => root,
        mode   => 664,
        content => template('apache2/enablesendfile.conf.erb'),
        notify => Service['apache2'],
        require => Package['apache2'],
    }

    exec { 'enable rewrite':
      creates => '/etc/apache2/mods-enabled/rewrite.load',
      command => '/usr/sbin/a2enmod rewrite',
      notify => Service['apache2'],
      require => Package['apache2'],
    }
}