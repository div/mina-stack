namespace :imagemagick do

  desc "Install the latest release of Imagemagick"
  task :install do
    invoke :sudo
    queue "sudo apt-get install imagemagick libmagickwand-dev -y"
  end

end