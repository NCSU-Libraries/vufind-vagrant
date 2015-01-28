Exec {
  path => '/usr/sbin:/usr/bin:/sbin:/bin',
}

package { [
    'default-jdk',
    'libapache2-mod-php5',
    'php5',
    'php5-curl', # needed for CAS
    'php5-dev',
    'php5-gd',
    'php5-intl',
    'php5-json',
    'php5-ldap',
    'php5-mcrypt',
    'php5-mysql',
    'php5-xdebug',
    'php5-xsl',
    'php-apc',
    'php-pear',
  ]:
  ensure => installed,
}

# Avoid package installation errors by running 'apt-get update' before
# attempting to install any packages if the APT cache has not been modified
# in over a week (inspired by http://stackoverflow.com/a/14754159):
exec { 'apt-update':
  command => 'apt-get update',
  onlyif => "expr `date +%s` - `stat -c%Y /var/cache/apt/` '>' 604800"
}
Exec['apt-update'] -> Package <| |>

# Other modules are enabled when they are installed,
# but Ubuntu's php5-mcrypt is not.
exec { 'php5enmod mcrypt':
  creates => '/etc/php5/apache2/conf.d/20-mcrypt.ini',
  notify => Service['apache2'],
  require => Package['php5-mcrypt'],
}

# This is a development setup, so we want xdebug available
# to be enabled, but the module can have a significant impact
# on performance when enabled, so disable it when provisioning:
exec { 'php5dismod xdebug':
  require => Package['php5-xdebug'],
  notify => Service['apache2'],
  onlyif => 'php5query -s apache2 -m xdebug || php5query -s cli -m xdebug',
}

##### MySQL setup #############################################################

class { '::mysql::server':
  root_password => 'UNSET',
}

##### Apache setup ############################################################

service { 'apache2':
  ensure => 'running',
  enable => 'true',
  require => Package['libapache2-mod-php5'],
}

file { '/etc/apache2/conf-enabled/vufind.conf':
  notify => Service['apache2'],
  ensure => 'link',
  target => '/usr/local/vufind/config/vufind/httpd-vufind.conf',
}

file { '/etc/apache2/mods-enabled/rewrite.load':
  notify => Service['apache2'],
  ensure => 'link',
  target => '/etc/apache2/mods-available/rewrite.load',
}

##### Solr setup ##############################################################

file { '/usr/local/vufind2':
  ensure => 'link',
  target => '/usr/local/vufind',
}

file { '/etc/init.d/vufind':
  ensure => 'link',
  target => '/usr/local/vufind/vufind.sh',
}

service { 'vufind':
  ensure => 'running',
  enable => 'true',
  require => [
    File['/etc/init.d/vufind'],
    File['/usr/local/vufind2'],
    Package['default-jdk'],
  ],
  hasstatus => false,
  status => 'sudo /etc/init.d/vufind check'
}
