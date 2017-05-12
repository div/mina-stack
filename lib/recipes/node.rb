namespace :node do
  desc "Install the latest relase of Node.js"
  task :install do
    invoke :sudo
    command "sudo apt-get -y update"
    command "sudo apt-get -y install software-properties-common python-software-properties python g++ make"
    command "curl -sL https://deb.nodesource.com/setup_0.12 | sudo bash -"
    command "sudo apt-get -y install nodejs"
  end
  task(:setup) {  }
end
