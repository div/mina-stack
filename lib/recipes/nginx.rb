namespace :nginx do

  desc "Install latest stable release of nginx"
  task :install do
    invoke :sudo
    command "sudo add-apt-repository ppa:nginx/stable --yes"
    command "sudo apt-get -y update"
    command "sudo apt-get -y install nginx"
  end

  desc "Upload and update (link) all nginx config file"
  task :setup => :environment do
    invoke :'nginx:upload'
    invoke :'nginx:link'
    invoke :'nginx:reload'
  end

  desc "Symlink config file"
  task :link do
    invoke :sudo
    comment "Symlink nginx config file"
    command echo_cmd %{sudo ln -fs "#{fetch(:config_path)}/nginx.conf" "#{fetch(:nginx_config)}"}
    command check_symlink fetch(:nginx_config)
    command echo_cmd %{sudo ln -fs "#{fetch(:config_path)}/nginx.conf" "#{fetch(:nginx_config_e)}"}
    command check_symlink fetch(:nginx_config_e)
  end

  desc "Parses nginx config file and uploads it to server"
  task :upload do
    template 'nginx.conf.erb', "#{fetch(:config_path)}/nginx.conf"
  end

  desc "Parses config file and outputs it to STDOUT (local task)"
  task :parse do
    puts "#"*80
    puts "# nginx.conf"
    puts "#"*80
    puts erb("#{fetch(:config_templates_path)}/nginx.conf.erb")
  end

  %w(stop start restart reload status).each do |action|
    desc "#{action.capitalize} Nginx"
    task action.to_sym do
      invoke :sudo
      comment "#{action.capitalize} Nginx"
      command echo_cmd "sudo service nginx #{action}"
    end
  end
end