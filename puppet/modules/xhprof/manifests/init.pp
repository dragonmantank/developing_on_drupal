class xhprof() {
	package {['build-essential', 'graphviz']:
		ensure => present,
		require => Class['php'],
	}

	exec {'xhprof-install':
		command => 'pecl install xhprof-0.9.4',
		creates => '/usr/share/php/xhprof_html',
		require => [Class['php'], Package['build-essential']],
	}

	file {'/etc/php5/apache2/conf.d/xhprof.ini':
		source => 'puppet:///modules/xhprof/xhprof.ini',
		require => Exec['xhprof-install'],
		notify => Service['apache2'],
	}

	file {'/etc/apache2/sites-enabled/xhprof.conf':
        owner  => root,
        group  => root,
        mode   => 664,
        source => 'puppet:///modules/xhprof/xhprof.conf',
        notify => Service['apache2'],
        require => [Package['apache2'], File['/etc/php5/apache2/conf.d/xhprof.ini']],
    }
}