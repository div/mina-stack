namespace :libcurl do

  desc "Install the latest release of libcurl"
  task :install do
    invoke :sudo
    queue "sudo apt-get -y install curl libcurl3 libcurl3-dev"
  end

  task(:setup) {  }

end

namespace :libxml do

  desc "Install the latest release of libxml"
  task :install do
    invoke :sudo
    queue "sudo apt-get -y install libxml2 libxml2-dev libxslt1-dev"
  end
  task(:setup) {  }

end