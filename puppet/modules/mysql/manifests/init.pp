class mysql (
  $root_password = 'vagrant',
  $db_name = 'main'
){
  package { "mysql-server":
    ensure => installed,
    require => Exec['apt-get update'],
  }

  service { 'mysql':
      ensure => 'running',
      enable => true,
      hasrestart => true,
      hasstatus => true,
      subscribe => Package['mysql-server'],
  }

  exec { "set-mysql-password":
    unless  => "mysql -uroot -p${root_password}",
    path    => ["/bin", "/usr/bin"],
    command => "mysqladmin -uroot password ${root_password}",
    require => Service["mysql"],
  }

  # Equivalent to /usr/bin/mysql_secure_installation without providing or setting a password
  exec { 'mysql_secure_installation':
      command => "/usr/bin/mysql -uroot -p${root_password} -e \"DELETE FROM mysql.user WHERE User=''; DROP DATABASE IF EXISTS test; FLUSH PRIVILEGES;\" mysql",
      require => Exec['set-mysql-password'],
  }

  exec { "create-database":
    unless  => "/usr/bin/mysql -uroot -p${root_password} ${db_name}",
    command => "/usr/bin/mysql -uroot -p${root_password} -e \"CREATE DATABASE IF NOT EXISTS ${db_name};\"",
    require => Exec["set-mysql-password"],
  }
}