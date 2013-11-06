node 'client-project-apache'{
   include git

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
   
}
