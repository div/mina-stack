namespace :puma do

  task(:install) {  }

  desc "Setup Puma configuration"
  task :setup => [:upload]

  desc "Create configuration and other files"
  task :upload do
    template "puma.rb.erb", puma_config
    queue  %[echo "-----> Be sure to edit #{puma_config}."]
  end

  desc 'Start puma'
  task :start do
    queue "#{puma_cmd} -d -e #{rails_env} -C #{puma_config}"
  end

  %w[stop restart phased-restart].each do |command|
    desc "#{command.titelize} puma"
    task command do
      queue "#{pumactl_cmd} -S #{puma_state} #{command}"
    end
  end

end