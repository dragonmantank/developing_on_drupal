class drupal (
	$db_name = 'main',
	$db_user = 'root',
	$db_pass = 'vagrant'
){
  exec {"install-drush":
  	environment => ["COMPOSER_HOME=/home/vagrant/.composer"],
  	command => "composer global require drush/drush:6.*",
  	require => [Exec['install-composer'], File['bash-profile']],
  	user => 'vagrant',
  }	

  exec {"download drupal":
    creates => '/vagrant/sites/default/default.settings.php',
    command => 'drush dl drupal --drupal-project-rename=drupal && rsync -avh drupal/ /vagrant/',
    require => Exec['install-drush'],
    path => ['/usr/bin', '/bin', '/home/vagrant/.composer/vendor/bin'],
    timeout => 0,
  }

  exec {'install drupal':
    creates => '/vagrant/sites/default/settings.php',
    command => "drush -y --db-url=mysql://${db_user}:${db_pass}@localhost/${db_name} --account-name=admin --account-pass=admin --site-name=Site --site-mail=admin@example.com",
    require => Exec['download drupal'],
    cwd => '/vagrant',
    path => ['/usr/bin', '/bin', '/home/vagrant/.composer/vendor/bin'],
    timeout => 0,
  }
}