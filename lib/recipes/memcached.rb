namespace :memcached do
  desc "Install Memcached"
  task :install => :environment do
    invoke :sudo
    command "sudo apt-get -y install memcached"
  end

  desc "Setup Memcached"
  task :setup => :environment do
    # template "memcached.erb", "/tmp/memcached.conf"
    # run "#{sudo} mv /tmp/memcached.conf /etc/memcached.conf"
    # restart
  end

  %w[start stop restart].each do |cmd|
    desc "#{cmd} Memcached"
    task cmd => :environment do
      command "sudo service memcached #{cmd}"
    end
  end
end