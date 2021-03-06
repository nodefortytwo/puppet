node 'client-project-apache'{
   include git
   include supervisor
   
   exec { "apt-get update":
       command => "/usr/bin/apt-get update",
       onlyif => "/bin/sh -c '[ ! -f /var/cache/apt/pkgcache.bin ] || /usr/bin/find /etc/apt/* -cnewer /var/cache/apt/pkgcache.bin | /bin/grep . > /dev/null'",
   }
   
   package { "python-setuptools":
          ensure => "latest",
          require  => Exec['apt-get update']
   }
   
   package { "python-pip":
          ensure => "latest",
          require  => Package['python-setuptools']
   }
   
   class {'apache':
      service_enable => false
   }
   
   class { '::mysql::server':
     override_options => { 'mysqld' => { 'max_connections' => '1024' } },
     service_enabled => false
   }
   
   apache::vhost { '*':
      port    => '80',
      docroot => '/var/www/',
   }
   
   exec { "pull repo" :
      command => 'git clone https://github.com/nodefortytwo/dd-php.git /var/www/',
      path    => ["/usr/bin", "/usr/sbin"]
   }
   
   supervisor::service { 'mysql':
      command   => '/usr/bin/mysqld_safe',
      ensure      => present,
      require  => Service['mysqld']
   }
   
   supervisor::service { 'apache':
      command   => '/etc/apache2/foreground.sh',
      ensure      => present,
      require  => Service['httpd']
   }
}
