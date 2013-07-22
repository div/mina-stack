namespace :bower do

  desc "Install bower with dependencies"
  task :install do
    invoke :sudo
    queue %{echo "-----> Installing Bower..."}
    queue "sudo npm install -g bower"
  end

  desc "Setup bower paths"
  task :setup do
  end

  desc "Install assets"
  task :install_assets do
    queue %{echo "-----> Installing Assets with Bower..."}
    queue "bower install"
  end

end