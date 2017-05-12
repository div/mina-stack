namespace :bower do

  desc "Install bower with dependencies"
  task :install do
    invoke :sudo
    comment "Installing Bower..."
    command "sudo npm install -g bower"
  end

  task(:setup) {  }

  desc "Install assets"
  task :install_assets do
    comment "Installing assets with Bower..."
    command "bower install"
  end

end