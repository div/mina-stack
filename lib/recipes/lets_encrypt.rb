namespace :lets_encrypt do

  desc "Install Let's Encrypt"
  task :install => :environment do
    invoke :sudo
    command "add-apt-repository ppa:certbot/certbot -y"
    command "apt-get update"
    command "apt-get install certbot -y"
  end
end