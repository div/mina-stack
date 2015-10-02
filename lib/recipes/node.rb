namespace :node do
  desc "Install the latest relase of Node.js"
  task :install do
    invoke :sudo
    queue "sudo apt-get -y update"
    queue "sudo apt-get -y install software-properties-common python-software-properties python g++ make"
    queue "curl -sL https://deb.nodesource.com/setup_0.12 | sudo bash -"
    queue "sudo apt-get -y install nodejs"
  end
  task(:setup) {  }
end
