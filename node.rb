namespace :nodejs do
  desc "Install the latest relase of Node.js"
  task :install, roles: :app do
    invoke :sudo
    queue "sudo apt-get -y update"
    queue "sudo apt-get -y install python-software-properties python g++ make"
    queue "sudo add-apt-repository ppa:chris-lea/node.js --yes"
    queue "sudo apt-get -y update"
    queue "sudo apt-get -y install nodejs"
  end
end