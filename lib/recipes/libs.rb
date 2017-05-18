namespace :libs do

  require 'highline/import'

  desc "Install some important libs"
  task :install => :environment do
    invoke :sudo
    command "sudo apt-get -y install curl libcurl3 libcurl3-dev"
    command "sudo apt-get -y install libxml2 libxml2-dev libxslt-dev"
    command "sudo apt-get -y install build-essential libssl-dev libcurl4-openssl-dev libreadline-dev libyaml-dev libffi-dev"
    command "sudo apt-get -y install libpq-dev"
    updates = ask "Do you want to enable Automatic Security Updates? [Y/n]"
    unless updates == 'n'
      command "sudo apt-get -y install unattended-upgrades"
    end
  end

  task :automatic_updates => :environment do
    invoke :sudo
_10_periodic = %[APT::Periodic::Update-Package-Lists "1";
APT::Periodic::Download-Upgradeable-Packages "1";
APT::Periodic::AutocleanInterval "7";
APT::Periodic::Unattended-Upgrade "1";]
    command %{sudo "echo '#{_10_periodic}' >> /etc/apt/apt.conf.d/10periodic"}
  end

  task(:setup) {  }

end
