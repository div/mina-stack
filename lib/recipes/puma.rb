namespace :puma do

  task(:install) {  }

  desc "Setup Puma configuration"
  task :setup => [:upload]

  desc "Create configuration and other files"
  task :upload do
    invoke :sudo
    template "puma.rb.erb", fetch(:puma_config)
    comment "Be sure to edit #{fetch(:puma_config)}."
    template "upstart/puma.conf.erb", "/tmp/puma_conf"
    command "sudo mv /tmp/puma_conf #{fetch(:puma_upstart)}"
  end

  %w[start stop restart reload].each do |cmd|
    desc "#{cmd.capitalize} puma"
    task cmd do
      comment "#{cmd.capitalize} puma."
      command "sudo #{cmd} #{fetch(:puma_name)}"
    end

    task phased_restart: :environment do
      command %[
      if [ -e '#{fetch(:pumactl_socket)}' ]; then
        cd #{fetch(:current_path)} && #{fetch(:pumactl_cmd)} -S #{fetch(:puma_state)} --pidfile #{fetch(:puma_pid)} phased-restart
      else
        echo 'Puma is not running!';
      fi
    ]
    end

  end

end
