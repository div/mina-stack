namespace :memcached do
  desc "Install Memcached"
  task :install do
    invoke :sudo
    queue "sudo apt-get -y install memcached"
  end

  # desc "Setup Memcached"
  # task :setup, roles: :app do
  #   template "memcached.erb", "/tmp/memcached.conf"
  #   run "#{sudo} mv /tmp/memcached.conf /etc/memcached.conf"
  #   restart
  # end

  %w[start stop restart].each do |command|
    desc "#{command} Memcached"
    task command do
      queue "sudo service memcached #{command}"
    end
  end
end