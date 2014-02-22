namespace :redis do

  desc "Install the latest release of Redis"
  task :install do
    invoke :sudo
    queue %{echo "-----> Installing Redis..."}
    queue "sudo add-apt-repository -y ppa:chris-lea/redis-server --yes"
    queue "sudo apt-get -y update"
    queue "sudo apt-get -y install redis-server"
  end

  task(:setup) {  }

  %w[start stop restart].each do |command|
    desc "#{command} redis"
    task command do
      invoke :sudo
      queue %{echo "-----> Trying to #{command} Redis..."}
      queue "sudo service redis #{command}"
    end
  end

end