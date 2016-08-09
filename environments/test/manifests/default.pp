Exec {
  path => '/usr/sbin:/usr/bin:/sbin:/bin',
}

package { [
    'epel-release',
    'composer',
    'java-1.8.0-openjdk-headless',
    'mariadb-server',
    'php',
    'php-mcrypt',
    'php-xml',
    'php-devel',
    'php-gd',
    'php-intl',
    'php-json',
    'php-ldap',
    'php-mysql',
    'php-xsl',
    # 'php-pecl-apc',
    'php-pear',
  ]:
  ensure => installed,
}

### composer setup

$composer_profile_template = @(END)
#!/bin/sh

export COMPOSER_HOME=/etc/composer/
END

file { "/etc/composer":
    ensure=> 'directory',
    owner => 'apache',
    group => 'apache',
    mode => '0755',
    recurse => true,
}


exec { "composer install":
    cwd => '/usr/local/vufind',
    path => [ '/usr/local/bin', '/usr/bin', '/bin', '/usr/sbin' ],
    environment => ["COMPOSER_HOME=/etc/composer"],
    user => 'apache',
    creates => '/usr/local/vufind/vendor',
}

file { '/etc/profile.d/composer.sh':
    ensure => present,
    owner => root,
    group => root,
    mode => '0755',
    content => inline_template($composer_profile_template),
} 

# open ports 80 and 8080 so we can access 'em from the host

exec { "firewall-80-open":
    command => "/usr/bin/firewall-cmd --zone=public --add-service=http --permanent",
}

exec { "firewall-8080-open":
    command => "/usr/bin/firewall-cmd --zone=public --add-port=8080/tcp --permanent",
}

exec { "firewalld-reload":
    command => "/usr/bin/firewall-cmd --reload",
}
    

service { 'mariadb':
    enable => true,
    ensure => running
}

##### Apache setup ############################################################

service { 'httpd':
  ensure => 'running',
  enable => 'true',
}

file { '/etc/httpd/conf.d/vufind.conf':
  notify => Service['httpd'],
  ensure => 'link',
  target => '/usr/local/vufind/config/vufind/httpd-vufind.conf',
}

##### Solr setup ##############################################################

file { '/usr/local/vufind2':
  ensure => 'link',
  target => '/usr/local/vufind',
}

file { '/etc/systemd/system/vufind.service': 
  ensure => 'present',
  source => '/tmp/vufind.service',
}

service { 'vufind':
  ensure => 'running',
  enable => 'true',
  require => [
    File['/etc/systemd/system/vufind.service'],
    Package['java-1.8.0-openjdk-headless'],
  ],
  hasstatus => false,
}


