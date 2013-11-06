node 'client-project-apache'{
   include git
   include supervisor
   
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
   
   class { 'supervisor': }
   
   supervisor::program { 'mysql':
      command   => '/usr/bin/mysqld_safe'
   }
   
   supervisor::program { 'apache':
      command   => '/etc/apache2/foreground.sh'
   }
}
