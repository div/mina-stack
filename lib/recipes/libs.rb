namespace :libs do

  desc "Install some important libs"
  task :install do
    invoke :sudo
    queue "sudo apt-get -y install curl libcurl3 libcurl3-dev"
    queue "sudo apt-get -y install libxml2 libxml2-dev libxslt-dev"
    queue "sudo apt-get -y install build-essential libssl-dev libcurl4-openssl-dev libreadline-dev libyaml-dev libffi-dev"

  end

  task(:setup) {  }

end
