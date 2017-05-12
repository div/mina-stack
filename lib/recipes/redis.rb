namespace :redis do

  desc "Install the latest release of Redis"
  task :install do
    invoke :sudo
    comment "Installing Redis"
    command "sudo add-apt-repository -y ppa:chris-lea/redis-server --yes"
    command "sudo apt-get -y update"
    command "sudo apt-get -y install redis-server"
  end

  task(:setup) {  }

  %w[start stop restart].each do |cmd|
    desc "#{cmd} redis"
    task cmd do
      invoke :sudo
      comment "#{cmd} Redis..."
      command "#{sudo} service redis #{cmd}"
    end
  end

end