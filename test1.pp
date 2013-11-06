node 'client-project-apache'{
   include git
   include supervisor
   
   package { "python-pip python-dev build-essential ":
          ensure => "latest"
   }
   
   package { "python-dev":
          ensure => "latest"
   }
   
   package { "build-essential ":
          ensure => "latest"
   }
   
   
   class { 'apache': }
   
   class { '::mysql::server':
     override_options => { 'mysqld' => { 'max_connections' => '1024' } }
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
      enable      => true,
   }
   
   supervisor::service { 'apache':
      command   => '/etc/apache2/foreground.sh',
      ensure      => present,
      enable      => true,
   }
}
