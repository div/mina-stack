namespace :bower do

  desc "Install bower with dependencies"
  task :install do
    invoke :sudo
    queue %{echo "-----> Installing Bower..."}
    queue "sudo npm install -g bower"
  end

  task(:setup) {  }

  desc "Install assets"
  task :install_assets do
    queue %{echo "-----> Installing Assets with Bower..."}
    queue "bower install"
  end

end