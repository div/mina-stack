namespace :sidekiq do

  task(:install) {  }

  desc "Setup sidekiq configuration"
  task :setup => [:upload]

  desc "Create configuration and other files"
  task :upload do
    invoke :sudo
    template "sidekiq.yml.erb", sidekiq_config
    queue  %[echo "-----> Be sure to edit #{sidekiq_config}."]
    template "upstart/sidekiq.conf.erb", "/tmp/sidekiq_conf"
    queue "sudo mv /tmp/sidekiq_conf #{sidekiq_upstart}"
  end

  %w[quiet].each do |command|
    desc "#{command.capitalize} sidekiq"
    task command do
      queue %{ if [ -f #{sidekiq_pid} ]; then
        echo "-----> #{command.capitalize} sidekiq"
        #{echo_cmd %{(cd #{deploy_to}/#{current_path} && #{sidekiqctl_cmd} #{command} #{sidekiq_pid})} }
        fi }
    end
  end

  desc "Restart Sidekiq"
  task :restart do
    invoke :'sidekiq:stop'
    invoke :'sidekiq:start'
  end

  %w[start stop].each do |command|
    desc "#{command.capitalize} sidekiq"
    task command do
      # need to get rid of sudo here: have to figure out how it works with upstart
      queue "sudo service #{sidekiq_name} #{command}"
      queue  %[echo "-----> #{command.capitalize} sidekiq."]
    end
  end
end