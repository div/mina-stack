namespace :node do
  desc "Install the latest relase of Node.js"
  task :install do
    invoke :sudo
    queue "sudo apt-get -y update"
    queue "sudo apt-get -y install software-properties-common python g++ make"
    queue "sudo add-apt-repository ppa:chris-lea/node.js --yes"
    queue "sudo apt-get -y update"
    queue "sudo apt-get -y install nodejs"
  end
  task(:setup) {  }
end