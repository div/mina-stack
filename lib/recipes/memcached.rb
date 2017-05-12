namespace :memcached do
  desc "Install Memcached"
  task :install do
    invoke :sudo
    command "sudo apt-get -y install memcached"
  end

  desc "Setup Memcached"
  task :setup do
    # template "memcached.erb", "/tmp/memcached.conf"
    # run "#{sudo} mv /tmp/memcached.conf /etc/memcached.conf"
    # restart
  end

  %w[start stop restart].each do |cmd|
    desc "#{cmd} Memcached"
    task cmd do
      command "sudo service memcached #{cmd}"
    end
  end
end