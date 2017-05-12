namespace :puma do

  task(:install) {  }

  desc "Setup Puma configuration"
  task :setup => [:upload]

  desc "Create configuration and other files"
  task :upload do
    invoke :sudo
    template "puma.rb.erb", fetch(:puma_config)
    comment %[Be sure to edit #{fetch(:puma_config)}."]
    template "upstart/puma.conf.erb", "/tmp/puma_conf"
    command "sudo mv /tmp/puma_conf #{fetch(:puma_upstart)}"
  end

  %w[start stop restart].each do |cmd|
    desc "#{cmd.capitalize} puma"
    task cmd do
      comment "#{command.capitalize} puma."
      command "sudo #{cmd} #{fetch(:puma_name)}"
    end
  end

  desc "Phased-restart puma"
  task :'phased-restart' do
    command "Phased-restart puma."
    command "sudo reload #{fetch(:puma_name)}"
  end

end
