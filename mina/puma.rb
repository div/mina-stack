namespace :puma do

  desc "Setup Puma configuration"
  task :setup => [:upload]

  desc "Create configuration and other files"
  task :upload do
    template "puma.rb.erb", puma_config
    queue  %[echo "-----> Be sure to edit #{puma_config}."]
  end

  desc "Start puma"
  task :start => :environment do
    queue "bundle exec puma -C #{puma_config} >> #{puma_log} 2>&1 &"
  end

  desc "Stop puma"
  task :stop do
    queue "kill -9 $(cat #{puma_pid})"
  end

  desc "Restart puma - zero downtime"
  task :restart do
    queue "kill -s USR1 $(cat #{puma_pid})"
    # queue "cd #{full_current_path} && bundle exec pumactl -S #{full_shared_path}/sockets/puma.state restart"
  end

  desc "Restart puma -force"
  task :force_restart do
    queue "kill -s USR2 $(cat #{puma_pid})"
  end

end