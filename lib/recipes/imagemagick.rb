namespace :imagemagick do

  desc "Install the latest release of Imagemagick"
  task :install do
    invoke :sudo
    comment "Installing the latest release of ImageMagick"
    command "sudo apt-get install imagemagick libmagickwand-dev -y"
  end

  task(:setup) {  }

end