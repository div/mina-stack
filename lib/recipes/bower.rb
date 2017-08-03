namespace :bower do

  desc "Install bower with dependencies"
  task :install => :environment do
    invoke :sudo
    comment "Installing Bower..."
    command "sudo npm install -g bower"
  end

  task(:setup => :environment) {  }

  desc "Install assets"
  task :install_assets => :environment do
    comment "Installing assets with Bower..."
    command "bower install"
  end

end