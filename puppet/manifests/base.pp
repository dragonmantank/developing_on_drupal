Exec { path => [ "/bin/", "/sbin/" , "/usr/bin/", "/usr/sbin/" ] }

define line($file, $line, $ensure = 'present') {
    case $ensure {
        default : { err ( "unknown ensure value ${ensure}" ) }
        present: {
            exec { "/bin/echo '${line}' >> '${file}'":
                unless => "/bin/grep -qFx '${line}' '${file}'"
            }
        }
        absent: {
            exec { "/bin/grep -vFx '${line}' '${file}' | /usr/bin/tee '${file}' > /dev/null 2>&1":
              onlyif => "/bin/grep -qFx '${line}' '${file}'"
            }

            # Use this resource instead if your platform's grep doesn't support -vFx;
            # note that this command has been known to have problems with lines containing quotes.
            # exec { "/usr/bin/perl -ni -e 'print unless /^\\Q${line}\\E\$/' '${file}'":
            #     onlyif => "/bin/grep -qFx '${line}' '${file}'"
            # }
        }
    }
}

exec { "apt-get update":
        
}

$system_packages = ['curl', 'git', 'vim', 'unzip']

package {$system_packages: 
  ensure => present,
  require => Exec['apt-get update']
}

file {'bash-profile':
  source => '/vagrant/puppet/files/bash_profile',
  path => '/home/vagrant/.bash_profile',
  owner => 'vagrant',
  group => 'vagrant',
}

include stdlib

class {'php': 
  usePHP55 => true
}

class {'xhprof': }

include mysql
include apache2
include drupal