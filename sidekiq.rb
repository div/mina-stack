namespace :sidekiq do

  desc "Setup sidekiq configuration"
  task :setup => [:upload]

  desc "Create configuration and other files"
  task :upload do
    template "sidekiq.yml.erb", sidekiq_config
    queue  %[echo "-----> Be sure to edit #{sidekiq_config}."]
  end

  desc "Quiet sidekiq (stop accepting new work)"
  task :quiet do
    queue %{ if [ -f #{sidekiq_pid} ]; then
      echo "-----> Quiet sidekiq (stop accepting new work)"
      #{echo_cmd %{(cd #{deploy_to}/#{current_path} && #{sidekiqctl_cmd} quiet #{sidekiq_pid})} }
      fi }
  end

  desc "Stop sidekiq"
  task :stop do
    queue %[ if [ -f #{sidekiq_pid} ]; then
      echo "-----> Stop sidekiq"
      #{echo_cmd %[(cd #{deploy_to}/#{current_path} && #{sidekiqctl_cmd} stop #{sidekiq_pid} #{sidekiq_timeout})]}
      fi ]
  end

  desc "Start sidekiq"
  task :start do
    queue %{
      echo "-----> Start sidekiq"
      #{echo_cmd %[(cd #{deploy_to}/#{current_path}; nohup #{sidekiq_cmd} -e #{rails_env} -C #{sidekiq_config} -P #{sidekiq_pid} >> #{sidekiq_log} 2>&1 </dev/null &) ] }
      }
  end

  desc "Restart sidekiq"
  task :restart do
    invoke :'sidekiq:stop'
    invoke :'sidekiq:start'
  end
end