namespace :puma do

  task(:install) {  }

  desc "Setup Puma configuration"
  task :setup => [:upload]

  desc "Create configuration and other files"
  task :upload do
    invoke :sudo
    template "puma.rb.erb", puma_config
    queue  %[echo "-----> Be sure to edit #{puma_config}."]
    template "upstart/puma.conf.erb", "/tmp/puma_conf"
    queue "sudo mv /tmp/puma_conf #{puma_upstart}"
  end

  desc 'Start puma'
  task :start do
    queue "#{puma_cmd} -d -e #{rails_env} -C #{puma_config}"
  end

  %w[stop restart phased-restart].each do |command|
    desc "#{command.capitalize} puma"
    task command do
      queue "#{pumactl_cmd} -S #{puma_state} #{command}"
    end
  end

end