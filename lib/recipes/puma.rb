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

  %w[start stop restart phased_restart phased-restart reload].each do |cmd|
    desc "#{cmd.capitalize} puma"
    task cmd do
      if cmd == 'phased_restart' || cmd == 'phased-restart'
        cmd = 'reload'
      end
      comment "#{cmd.capitalize} puma."
      command "sudo #{cmd} #{fetch(:puma_name)}"
    end
  end

end
