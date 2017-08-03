namespace :lets_encrypt do
  require 'highline/import'

  desc "Install Let's Encrypt"
  task :install => :environment do
    invoke :sudo
    command "add-apt-repository ppa:certbot/certbot -y"
    command "apt-get update"
    command "apt-get install certbot -y"
    unless fetch(:lets_encrypt_email).present?
      lets_encrypt_email = ask "What email do you want to use for Let's Encrypt?"
    end
    set :lets_encrypt_email, lets_encrypt_email.strip
    command "sudo certbot certonly -a webroot --email #{fetch(:lets_encrypt_email)} --webroot-path=/usr/share/nginx/html -d #{fetch(:server_name)}"
    command "If successful, you should set `set :lets_encrypt, true` in your mina deploy environment and then run `mina nginx:setup`"
  end
end