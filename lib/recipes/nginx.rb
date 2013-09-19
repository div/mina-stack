###########################################################################
# nginx Tasks
###########################################################################

namespace :nginx do

  desc "Install latest stable release of nginx"
  task :install do
    invoke :sudo
    queue "sudo add-apt-repository ppa:nginx/stable --yes"
    queue "sudo apt-get -y update"
    queue "sudo apt-get -y install nginx"
  end

  desc "Create configuration and other files"
  task :setup => [:update]

  desc "Upload and update (link) all nginx config file"
  task :update => [:upload, :link, :reload]

  desc "Symlink config file"
  task :link do
    invoke :sudo
    queue %{echo "-----> Symlink nginx config file"}
    queue echo_cmd %{sudo ln -fs "#{config_path}/nginx.conf" "#{nginx_config}"}
    queue check_symlink nginx_config
    queue echo_cmd %{sudo ln -fs "#{config_path}/nginx.conf" "#{nginx_config_e}"}
    queue check_symlink nginx_config_e
  end

  desc "Parses nginx config file and uploads it to server"
  task :upload do
    template 'nginx.conf.erb', "#{config_path}/nginx.conf"
  end

  desc "Parses config file and outputs it to STDOUT (local task)"
  task :parse do
    puts "#"*80
    puts "# nginx.conf"
    puts "#"*80
    puts erb("#{config_templates_path}/nginx.conf.erb")
  end

  %w(stop start restart reload status).each do |action|
    desc "#{action.capitalize} Nginx"
    task action.to_sym do
      queue %{echo "-----> #{action.capitalize} Nginx"}
      queue echo_cmd "sudo service nginx #{action}"
    end
  end
end